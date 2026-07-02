/**
 * capture.js — 支付宝小游戏扫码登录 & 网络请求捕获脚本
 *
 * 功能:
 *   1. 启动 Chrome 浏览器（非无头模式，方便扫码）
 *   2. 导航到游戏登录页
 *   3. 监听所有网络请求，重点标记 iframe 内部请求
 *   4. 对包含 'api'、'game'、'data' 等关键词的 URL 做特殊高亮输出
 *   5. 检测登录成功后，自动保存 cookies + localStorage 到 state.json
 *   6. 120 秒未检测到登录成功则超时退出
 *
 * 运行方式:
 *   node capture.js
 *
 * 首次使用前:
 *   1. 将下方 LOGIN_URL 替换为实际的游戏登录页地址
 *   2. 可根据需要调整 KEYWORDS（高亮关键词）
 *   3. 确保已安装依赖: npm install playwright && npx playwright install chromium
 */

const { chromium } = require('playwright');
const path = require('path');
const fs = require('fs');

// ========================= 配置区域 =========================

/** 游戏登录页 URL —— 请替换为实际地址 */
const LOGIN_URL = 'https://www.wanyiwan.top/login/sgzhd';

/** 网络请求中需要高亮标记的关键词（不区分大小写） */
const KEYWORDS = ['api', 'game', 'data', 'auth', 'token', 'login', 'user', 'session'];

/** 超时时间（毫秒），超过此时间未登录成功则自动退出 */
const TIMEOUT_MS = 120 * 1000;

/** 登录状态保存路径 */
const STATE_FILE = path.join(__dirname, 'state.json');

/** 轮询检测登录状态的间隔（毫秒） */
const POLL_INTERVAL_MS = 1000;

// ========================= 工具函数 =========================

/**
 * 格式化时间戳为 HH:MM:SS
 */
function formatTime() {
  const now = new Date();
  return now.toLocaleTimeString('zh-CN', { hour12: false });
}

/**
 * 判断请求是否来自 iframe
 * Playwright 中每个 Frame 都有独立的请求上下文，
 * request.frame() 返回发起请求的 Frame 对象。
 * 与 page.mainFrame() 比较即可区分 iframe 请求。
 */
function isIframeRequest(request, mainFrame) {
  const frame = request.frame();
  // frame 可能为 null（如 Service Worker 发起的请求），视为非 iframe
  if (!frame) return false;
  return frame !== mainFrame;
}

/**
 * 检查 URL 是否包含任意一个关键词
 */
function matchesKeywords(url, keywords) {
  const lower = url.toLowerCase();
  return keywords.some(kw => lower.includes(kw));
}

/**
 * 截断过长的 URL 以便控制台输出
 */
function truncateUrl(url, maxLen = 120) {
  if (url.length <= maxLen) return url;
  return url.slice(0, maxLen) + '…';
}

// ========================= 登录检测策略 =========================

/**
 * 检查当前页面状态是否表明已登录成功。
 *
 * 检测策略（按优先级）：
 *   1. URL 变化 — 页面从登录页跳转到了其他地址（最常见）
 *   2. Cookie 检测 — 出现了典型的认证 Cookie
 *   3. DOM 元素检测 — 页面上出现了游戏相关元素（如角色名、游戏界面等）
 *
 * 这些策略可组合使用，任一命中即认为登录成功。
 */
function createLoginDetector(page, loginUrl) {
  // 解析登录 URL，用于后续比较
  const loginUrlObj = new URL(loginUrl);
  const loginHostname = loginUrlObj.hostname;
  const loginPathname = loginUrlObj.pathname;

  /**
   * 策略 1: URL 路径是否已改变
   */
  async function checkUrlChanged() {
    const currentUrl = page.url();
    try {
      const currentUrlObj = new URL(currentUrl);
      // 同域名下路径变化，或完全跳转到不同域名，都视为登录成功
      if (currentUrlObj.hostname !== loginHostname) return true;
      if (currentUrlObj.pathname !== loginPathname && currentUrlObj.pathname !== '/') return true;
    } catch {
      // URL 解析失败，忽略
    }
    return false;
  }

  /**
   * 策略 2: 是否出现了认证相关的 Cookie
   * 支付宝体系常见的 Cookie 名称关键词
   */
  async function checkAuthCookies() {
    const cookies = await page.context().cookies();
    const authCookieNames = [
      'ALIPAYJSESSIONID',
      'JSESSIONID',
      'SESSION',
      'token',
      'auth',
      'userId',
      'uid',
      'login_token',
      'access_token',
    ];
    return cookies.some(c =>
      authCookieNames.some(name => c.name.toLowerCase().includes(name.toLowerCase()))
    );
  }

  /**
   * 策略 3: 页面是否不再包含登录相关元素（如二维码、登录按钮等）
   */
  async function checkDomChanged() {
    try {
      // 检查常见的登录页面元素是否已消失
      const loginSelectors = [
        '[class*="qrcode"]',
        '[class*="login"]',
        '[class*="scan"]',
        '.qrcode',
        '#qrcode',
        'canvas', // 二维码通常是 canvas 元素
      ];
      for (const sel of loginSelectors) {
        const el = await page.$(sel);
        if (el) return false; // 还有登录元素，未登录
      }
      // 没有找到任何登录元素，可能已登录
      return true;
    } catch {
      return false;
    }
  }

  /**
   * 综合检测：任一策略命中即返回 true
   */
  async function isLoggedIn() {
    const urlChanged = await checkUrlChanged();
    if (urlChanged) {
      console.log(`\n[${formatTime()}] ✅ 检测到 URL 变化 → 登录成功 (当前: ${page.url()})`);
      return true;
    }

    const hasAuthCookie = await checkAuthCookies();
    if (hasAuthCookie) {
      const cookies = await page.context().cookies();
      const authCookie = cookies.find(c =>
        ['ALIPAYJSESSIONID', 'JSESSIONID', 'SESSION', 'token', 'auth', 'userId', 'uid'].some(
          n => c.name.toLowerCase().includes(n.toLowerCase())
        )
      );
      console.log(`\n[${formatTime()}] ✅ 检测到认证 Cookie → 登录成功 (${authCookie?.name})`);
      return true;
    }

    return false;
  }

  return { isLoggedIn, checkUrlChanged, checkAuthCookies, checkDomChanged };
}

// ========================= 主流程 =========================

async function main() {
  console.log('╔══════════════════════════════════════════════╗');
  console.log('║   支付宝小游戏 扫码登录 & 请求捕获工具      ║');
  console.log('╚══════════════════════════════════════════════╝\n');

  // ---------- 启动浏览器 ----------
  console.log(`[${formatTime()}] 🚀 正在启动 Chrome 浏览器...`);
  const browser = await chromium.launch({
    headless: false, // 非无头模式，方便观察和扫码
    args: [
      '--disable-blink-features=AutomationControlled', // 隐藏自动化标记
    ],
  });

  // 创建浏览器上下文
  const context = await browser.newContext({
    // 设置一个合理的视口大小
    viewport: { width: 1280, height: 800 },
    // 设置中文语言，避免页面显示异常
    locale: 'zh-CN',
  });

  const page = await context.newPage();
  const mainFrame = page.mainFrame();

  // ---------- 网络请求统计 ----------
  let requestCount = 0;
  let iframeRequestCount = 0;
  let highlightedRequestCount = 0;

  // ---------- 注册网络请求监听 ----------
  console.log(`[${formatTime()}] 👂 开始监听网络请求...\n`);

  page.on('request', request => {
    requestCount++;
    const url = request.url();
    const method = request.method();
    const isIframe = isIframeRequest(request, mainFrame);
    const hasKeyword = matchesKeywords(url, KEYWORDS);

    // 构建输出前缀
    let prefix;
    if (isIframe && hasKeyword) {
      prefix = '🔴 IFRAME+KEY';
      iframeRequestCount++;
      highlightedRequestCount++;
    } else if (isIframe) {
      prefix = '🟡 IFRAME    ';
      iframeRequestCount++;
    } else if (hasKeyword) {
      prefix = '🟠 MAIN+KEY ';
      highlightedRequestCount++;
    } else {
      prefix = '⚪ MAIN      ';
    }

    // 格式化输出
    const timestamp = formatTime();
    const truncated = truncateUrl(url);
    const resourceType = request.resourceType();
    const typeStr = resourceType ? `[${resourceType}]` : '';

    if (isIframe || hasKeyword) {
      // iframe 请求或含关键词请求 — 完整输出
      console.log(`[${timestamp}] ${prefix} ${method} ${typeStr} ${truncated}`);
    }

    // 对于非常重要的请求（iframe + 关键词），额外高亮
    if (isIframe && hasKeyword) {
      console.log(`         >>> ⭐ 重点关注: 该请求来自 iframe 且包含关键业务关键词 <<<`);
    }
  });

  // 也监听响应，用于捕获响应状态
  page.on('response', response => {
    const request = response.request();
    const isIframe = isIframeRequest(request, mainFrame);
    const url = request.url();

    // 仅对 iframe 中的重要请求输出响应状态
    if (isIframe && matchesKeywords(url, KEYWORDS)) {
      const status = response.status();
      const statusEmoji = status >= 200 && status < 300 ? '✅' : status >= 400 ? '❌' : '⚠️';
      console.log(`         ${statusEmoji} 响应状态: ${status} ${response.statusText()}`);
    }
  });

  // ---------- 监听控制台消息（调试用） ----------
  page.on('console', msg => {
    if (msg.type() === 'error') {
      console.log(`[${formatTime()}] 🌐 页面控制台错误: ${msg.text().slice(0, 200)}`);
    }
  });

  // ---------- 导航到登录页 ----------
  console.log(`[${formatTime()}] 🌐 正在导航到登录页: ${LOGIN_URL}\n`);

  try {
    await page.goto(LOGIN_URL, {
      waitUntil: 'networkidle', // 等待网络空闲，确保登录页完全加载
      timeout: 30000,           // 30 秒加载超时
    });
    console.log(`[${formatTime()}] ✅ 登录页加载完成`);
    console.log(`[${formatTime()}] 📱 当前页面 URL: ${page.url()}\n`);
  } catch (err) {
    console.error(`[${formatTime()}] ❌ 登录页加载失败: ${err.message}`);
    console.error('请检查 LOGIN_URL 是否正确，以及网络连接是否正常。');
    await browser.close();
    process.exit(1);
  }

  // ---------- 等待用户扫码登录 ----------
  console.log('┌──────────────────────────────────────────────┐');
  console.log('│  📱 请使用支付宝扫描页面上的二维码完成登录    │');
  console.log('│  ⏳ 等待登录完成中（最长等待 120 秒）...      │');
  console.log('│  💡 登录成功后脚本将自动继续执行              │');
  console.log('└──────────────────────────────────────────────┘\n');

  const detector = createLoginDetector(page, LOGIN_URL);
  const startTime = Date.now();
  let loggedIn = false;

  while (Date.now() - startTime < TIMEOUT_MS) {
    try {
      loggedIn = await detector.isLoggedIn();
      if (loggedIn) break;
    } catch (err) {
      // 检测过程中的异常忽略（如页面正在导航中等）
      console.log(`[${formatTime()}] ⚠️ 检测时出现临时异常: ${err.message.slice(0, 100)}`);
    }

    // 等待一段时间再重试
    await page.waitForTimeout(POLL_INTERVAL_MS);

    // 每 10 秒输出一次等待提示
    const elapsed = Math.floor((Date.now() - startTime) / 1000);
    if (elapsed > 0 && elapsed % 10 === 0) {
      console.log(`[${formatTime()}] ⏳ 仍在等待登录... (已等待 ${elapsed} 秒)`);
    }
  }

  // ---------- 超时处理 ----------
  if (!loggedIn) {
    console.log('\n┌──────────────────────────────────────────────┐');
    console.log('│  ⏰ 超时！                                    │');
    console.log(`│  已等待 ${TIMEOUT_MS / 1000} 秒，未检测到登录成功            │`);
    console.log('│  请检查：                                     │');
    console.log('│  1. 是否正确扫描了二维码                      │');
    console.log('│  2. 支付宝是否已确认登录                      │');
    console.log('│  3. 登录页 URL 是否正确                      │');
    console.log('└──────────────────────────────────────────────┘\n');

    // 超时时也尝试保存当前状态，可能仍有价值
    try {
      await context.storageState({ path: STATE_FILE });
      console.log(`[${formatTime()}] 💾 超时时保存了当前浏览器状态至 ${STATE_FILE}`);
    } catch (err) {
      console.error(`[${formatTime()}] ⚠️ 保存状态失败: ${err.message}`);
    }

    console.log('\n按 Enter 键关闭浏览器...');
    await waitForEnter();
    await browser.close();
    console.log(`[${formatTime()}] 👋 浏览器已关闭\n`);

    console.log('══════════════════════════════════════════════');
    console.log('  运行统计:');
    console.log(`    总请求数:       ${requestCount}`);
    console.log(`    iframe 请求数:   ${iframeRequestCount}`);
    console.log(`    关键词命中请求:  ${highlightedRequestCount}`);
    console.log(`    登录状态:        ❌ 超时未登录`);
    console.log('══════════════════════════════════════════════\n');
    process.exit(1);
  }

  // ---------- 登录成功，保存状态 ----------
  console.log(`\n[${formatTime()}] 🎉 登录成功！`);

  try {
    await context.storageState({ path: STATE_FILE });
    console.log(`[${formatTime()}] 💾 登录状态已保存至: ${STATE_FILE}`);
  } catch (err) {
    console.error(`[${formatTime()}] ❌ 保存状态失败: ${err.message}`);
  }

  // ---------- 输出最终统计 ----------
  console.log('\n══════════════════════════════════════════════');
  console.log('  运行统计:');
  console.log(`    总请求数:       ${requestCount}`);
  console.log(`    iframe 请求数:   ${iframeRequestCount}`);
  console.log(`    关键词命中请求:  ${highlightedRequestCount}`);
  console.log(`    登录状态:        ✅ 已登录`);
  console.log(`    耗时:            ${Math.floor((Date.now() - startTime) / 1000)} 秒`);
  console.log(`    状态文件:        ${STATE_FILE}`);
  console.log('══════════════════════════════════════════════\n');

  // 登录成功后保持浏览器打开一段时间，方便观察
  console.log('🕐 浏览器将保持打开 10 秒，方便观察页面状态...');
  console.log('   按 Enter 键可立即关闭浏览器\n');
  await Promise.race([
    page.waitForTimeout(10000),
    waitForEnter(),
  ]);

  await browser.close();
  console.log(`[${formatTime()}] 👋 浏览器已关闭，脚本执行完毕。\n`);
}

/**
 * 等待用户在终端按 Enter 键
 * 用于给用户留出观察时间
 */
function waitForEnter() {
  return new Promise(resolve => {
    const { stdin } = process;
    if (!stdin.isTTY) {
      resolve();
      return;
    }
    stdin.setRawMode?.(true);
    stdin.resume();
    const onData = data => {
      if (data.toString() === '\r' || data.toString() === '\n') {
        stdin.removeListener('data', onData);
        stdin.setRawMode?.(false);
        stdin.pause();
        resolve();
      }
    };
    stdin.on('data', onData);
  });
}

// ========================= 入口 =========================

main().catch(err => {
  console.error(`\n[${formatTime()}] 💥 脚本发生未预期的错误:`);
  console.error(err);
  process.exit(1);
});
