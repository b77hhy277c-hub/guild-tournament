import re, tempfile, subprocess, os

def verify_js(content, label):
    """Check JS syntax"""
    m = re.search(r'<script>([\s\S]*?)</script>', content)
    if not m:
        return True  # no script to check
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
# Part 1: Bathhouse calculators (6 files)
# ============================================================
bath_files = {
    'calculator/bathhouse/female.html': 'bath_female',
    'calculator/bathhouse/male.html': 'bath_male',
    'calculator/bathhouse/massage.html': 'bath_massage',
    'calculator/bathhouse/sauna.html': 'bath_sauna',
    'calculator/bathhouse/tcm.html': 'bath_tcm',
    'calculator/bathhouse/vip.html': 'bath_vip',
}

for f, ctype in bath_files.items():
    with open(f, 'r') as fp:
        content = fp.read()

    # 1. Empty out talents arrays in techs (keep project IDs)
    # Pattern: {id:'12号',talents:['a','b','c']} → {id:'12号',talents:[]}
    content = re.sub(r"\{id:'([^']+)',talents:\[[^\]]*\]", r"{id:'\1',talents:[]", content)

    # 2. Add loadProjectTalents function before loadOwnedTalents
    load_fn = '''
async function loadProjectTalents(){
\ttry{
\t\tvar rows=await API.get('calculator_project_talents?calculator_type=eq.'+DEPT.calcType+'&select=project_id,talent_name&order=sort_order.asc');
\t\tvar map={};
\t\trows.forEach(function(r){
\t\t\tif(!map[r.project_id])map[r.project_id]=[];
\t\t\tmap[r.project_id].push(r.talent_name);
\t\t});
\t\tDEPT.techs.forEach(function(tech){if(map[tech.id])tech.talents=map[tech.id];});
\t}catch(e){console.error(e);}
}
'''
    # Insert before loadOwnedTalents
    old_fn = 'async function loadOwnedTalents(){'
    new_fn = load_fn + '\n' + old_fn
    if old_fn in content:
        content = content.replace(old_fn, new_fn)
    else:
        print(f'{f}: loadOwnedTalents NOT FOUND')
        continue

    # 3. Update init() to load project talents first
    # Old pattern:
    #   loadOwnedTalents().then(function(){loadSavedData().then(function(saved){try{renderInputTable(saved);}...
    # New pattern:
    #   loadProjectTalents().then(function(){loadOwnedTalents().then(function(){loadSavedData().then(function(saved){try{renderInputTable(saved);}...

    old_init_load = "loadOwnedTalents().then(function(){loadSavedData().then(function(saved){try{renderInputTable(saved);}catch(e){document.getElementById('inputBody').innerHTML="
    new_init_load = "loadProjectTalents().then(function(){" + old_init_load

    if old_init_load in content:
        content = content.replace(old_init_load, new_init_load)
    else:
        print(f'{f}: init load chain NOT FOUND')
        continue

    # Need to add extra closing }) for the new .then wrapper
    # The original ends with: ...}).catch(function(e){...});
    # Need to become: ...}).catch(function(e){...});})
    # Find the catch at end of init
    old_catch = ".catch(function(e){document.getElementById('inputBody').innerHTML='<tr><td colspan=\"7\" style=\"color:red;padding:20px;\">加载错误: '+e.message+'</td></tr>';});"
    new_catch = old_catch + "});"
    if old_catch in content:
        content = content.replace(old_catch, new_catch)
    else:
        print(f'{f}: init catch NOT FOUND')
        continue

    if not verify_js(content, f'{f} after changes'):
        continue

    with open(f, 'w') as fp:
        fp.write(content)
    print(f'{f}: OK')
