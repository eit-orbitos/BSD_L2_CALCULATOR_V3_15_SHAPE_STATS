# Compares the recorded SageMath example output in validation/sage_output/
# with the reference CSVs in data/. Run from anywhere: python3 validation/check_sage_outputs_v3_15_4.py
import csv,re,sys
import os
ROOT=os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
V=os.path.join(ROOT,'validation','sage_output')+'/'; R=os.path.join(ROOT,'data')+'/'
TOL_REF=1e-9   # relative; Sage output printed with 12 significant digits, CSV with ~15
TOL_SQ=1e-4    # nearest_square tolerance documented in bsd_calculator.sage
fails=[];checks=0
def chk(c,msg):
    global checks; checks+=1
    if not c: fails.append(msg)
def rel(a,b): return abs(a-b)/max(abs(b),1e-300)
def parse(path):
    shape,bsd,cur=[],[],None
    for line in open(path):
        line=line.rstrip('\n')
        if line.startswith('label,N,P_reduced'): cur=shape; continue
        if line.startswith('label,N,rank'): cur=bsd; continue
        if not line or line.startswith('  '): continue
        if cur is not None: cur.append(line)
    return shape,bsd
def bsdrow(l):
    # label may contain commas inside [...]
    m=re.match(r'^(\[.*?\]|[^,]+),(.*)$',l); f=m.group(2).split(',')
    return dict(N=int(f[0]),rank=int(f[1]),lead=float(f[2]),reg=float(f[5]),sha=float(f[8]),sq=float(f[9]),err=float(f[10]),ok=f[11])
def shaperow(l):
    f=l.split(',')
    return dict(label=f[0],h1=float(f[4]),h2=float(f[5]),b=float(f[6]),det=float(f[7]),s2=float(f[8]),th=float(f[9]),e1=float(f[10]),e2=float(f[11]),red=f[12],sat=f[13])
def refs(fn): return {r['label']:r for r in csv.DictReader(open(R+fn))}
summary=[]
# rank0
_,b=parse(V+'rank0_sha9.out'); chk(len(b)==3,'rank0 count')
for l in b:
    r=bsdrow(l); chk(r['rank']==0 and r['sq']==9 and r['err']<TOL_SQ and r['ok']=='True',f'rank0 {l}')
summary.append(f"rank0: {len(b)} curves, sha_proxy nearest square 9, max rel err {max(bsdrow(l)['err'] for l in b):.3e}")
for fn,out,n,shaexp in [('shape_stats_reduced_basis_v3_15_4.csv','rank2_sha1_shape_stats.out',19,1),('rank2_sha4_candidates_v3_15_4.csv','rank2_sha4_194766c4.out',2,4)]:
    ref=refs(fn); s,b=parse(V+out); chk(len(s)==n and len(b)==n,f'{out} count')
    worst=0
    for l in s:
        r=shaperow(l); x=ref[r['label']]
        for k,ck in [('h1','h1_red'),('h2','h2_red'),('b','b12_red'),('det','Reg'),('s2','sin2_reduced'),('th','theta_reduced_deg')]:
            e=rel(r[k],float(x[ck])); worst=max(worst,e); chk(e<TOL_REF,f"{r['label']} {k} rel {e:.2e}")
        chk(r['e1']<1e-12 and r['e2']<1e-12,f"{r['label']} gram vs regulator")
        chk(r['red']=='True' and r['sat']=='1',f"{r['label']} reduced/sat")
        chk(0.75<=r['s2']<=1 and 0<r['th']<=90,f"{r['label']} sin2 range / acute")
    for l,lab in zip(b,[shaperow(x)['label'] for x in s]):
        r=bsdrow(l); x=ref[lab]
        chk(r['rank']==2 and r['sq']==shaexp and r['err']<TOL_SQ and r['ok']=='True',f'{lab} sha')
        e=rel(r['lead'],float(x['lead_Lr_over_rfact'])); worst=max(worst,e); chk(e<TOL_REF,f'{lab} lead rel {e:.2e}')
    s2=[shaperow(l)['s2'] for l in s]
    summary.append(f"{out}: {n} curves, sha nearest square {shaexp}, max rel dev vs CSV {worst:.2e}, sin2 range [{min(s2):.12g}, {max(s2):.12g}]")
# 655a1
L=open(V+'basis_dependence_655a1.out').read().splitlines()
d={l.split(':')[0]:dict(re.findall(r'(\w+) = ([\w.\-e]+)',l)) for l in L}
c,sk,rd=d['cremona'],d['skewed'],d['skewed_then_reduced']
chk(rel(float(sk['gram_det']),float(c['gram_det']))<1e-9,'655 det preserved')
chk(float(sk['sin2theta'])<0.75 and sk['gauss_reduced']=='False','655 skew changes angle')
chk(rel(float(rd['sin2theta']),float(c['sin2theta']))<1e-9 and rd['gauss_reduced']=='True','655 reduction restores')
chk(rel(float(c['sin2theta']),float(refs('shape_stats_reduced_basis_v3_15_4.csv')['655a1']['sin2_reduced']))<TOL_REF,'655 vs ref')
summary.append(f"655a1: det cremona/skewed/reduced = {c['gram_det']}/{sk['gram_det']}/{rd['gram_det']}; sin2 = {c['sin2theta']}/{sk['sin2theta']}/{rd['sin2theta']}")
print('\n'.join(summary)); print(f'CHECKS {checks-len(fails)}/{checks} PASS'); print('\n'.join(fails))
sys.exit(1 if fails else 0)
