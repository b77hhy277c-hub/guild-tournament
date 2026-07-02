import re, tempfile, subprocess, os

def verify_js(content, label):
    m = re.search(r'<script>([\s\S]*?)</script>', content)
    if not m: return True
    tmp = tempfile.NamedTemporaryFile(mode='w', suffix='.js', delete=False, encoding='utf-8')
    tmp.write(m.group(1))
    tmp.close()
    result = subprocess.run(['node', '--check', tmp.name], capture_output=True, text=True)
    os.unlink(tmp.name)
    if result.returncode != 0:
        print(f'  JS ERROR ({label}): {result.stderr.strip()[:200]}')
        return False
    return True

# ============================================================
# Farm Talent Food & Meat
# ============================================================
for f, ctype in [
    ('calculator/farm-talent-food.html', 'farm_talent_food'),
    ('calculator/farm-talent-meat.html', 'farm_talent_meat'),
]:
    with open(f, 'r') as fp:
        content = fp.read()

    # 1. Empty talents arrays in SECTIONS
    content = re.sub(r"\{name:'([^']+)',\s*talents:\[[^\]]*\]", r"{name:'\1',talents:[]", content)

    # 2. Add loadProjectTalents for farm talent (uses SECTIONS and CALC_TYPE)
    load_fn = '''
async function loadProjectTalents(){
\ttry{
\t\tvar rows=await API.get('calculator_project_talents?calculator_type=eq.'+CALC_TYPE+'&select=project_id,talent_name&order=sort_order.asc');
\t\tvar map={};
\t\trows.forEach(function(r){
\t\t\tif(!map[r.project_id])map[r.project_id]=[];
\t\t\tmap[r.project_id].push(r.talent_name);
\t\t});
\t\tSECTIONS.forEach(function(sec){if(map[sec.name])sec.talents=map[sec.name];});
\t}catch(e){console.error(e);}
}
'''
    old_fn = 'async function loadOwnedTalents(){'
    if old_fn in content:
        content = content.replace(old_fn, load_fn + '\n' + old_fn)
    else:
        print(f'{f}: loadOwnedTalents NOT FOUND')
        continue

    # 3. Update init() load chain
    old_init_load = "loadOwnedTalents().then(function(){loadSavedData().then(function(saved){try{renderInputTable(saved);}catch(e){document.getElementById('inputBody').innerHTML="
    new_init_load = "loadProjectTalents().then(function(){" + old_init_load
    if old_init_load in content:
        content = content.replace(old_init_load, new_init_load)
    else:
        print(f'{f}: init load chain NOT FOUND')
        continue

    old_catch = ".catch(function(e){document.getElementById('inputBody').innerHTML='<tr><td colspan=\"7\" style=\"color:red;padding:20px;\">加载错误: '+e.message+'</td></tr>';});"
    new_catch = old_catch + "});"
    if old_catch in content:
        content = content.replace(old_catch, new_catch)
    else:
        print(f'{f}: init catch NOT FOUND')
        continue

    if not verify_js(content, f):
        continue

    with open(f, 'w') as fp:
        fp.write(content)
    print(f'{f}: OK')

# ============================================================
# Farm Artist
# ============================================================
f = 'calculator/farm-artist.html'
with open(f, 'r') as fp:
    content = fp.read()

# 1. Empty artists arrays in PROJECTS
content = re.sub(r"\{name:'([^']+)',\s*artists:\[[^\]]*\]", r"{name:'\1',artists:[]", content)

# 2. Add loadProjectTalents for farm artist (uses PROJECTS and CALC_TYPE, loads artists not talents)
load_fn = '''
async function loadProjectTalents(){
\ttry{
\t\tvar rows=await API.get('calculator_project_talents?calculator_type=eq.'+CALC_TYPE+'&select=project_id,talent_name&order=sort_order.asc');
\t\tvar map={};
\t\trows.forEach(function(r){
\t\t\tif(!map[r.project_id])map[r.project_id]=[];
\t\t\tmap[r.project_id].push(r.talent_name);
\t\t});
\t\tPROJECTS.forEach(function(proj){if(map[proj.name])proj.artists=map[proj.name];});
\t}catch(e){console.error(e);}
}
'''
old_fn = 'async function loadOwnedArtists(){'
if old_fn in content:
    content = content.replace(old_fn, load_fn + '\n' + old_fn)
else:
    print(f'{f}: loadOwnedArtists NOT FOUND')

# 3. Update init() load chain
old_init_load = "loadOwnedArtists().then(function(){loadSavedData().then(function(saved){try{renderInputTable(saved);}catch(e){document.getElementById('inputBody').innerHTML="
new_init_load = "loadProjectTalents().then(function(){" + old_init_load
if old_init_load in content:
    content = content.replace(old_init_load, new_init_load)
else:
    print(f'{f}: init load chain NOT FOUND')

old_catch = ".catch(function(e){document.getElementById('inputBody').innerHTML='<tr><td colspan=\"5\" style=\"color:red;padding:20px;\">加载错误: '+e.message+'</td></tr>';});"
new_catch = old_catch + "});"
if old_catch in content:
    content = content.replace(old_catch, new_catch)
else:
    print(f'{f}: init catch NOT FOUND')

if not verify_js(content, f):
    exit()

with open(f, 'w') as fp:
    fp.write(content)
print(f'{f}: OK')
