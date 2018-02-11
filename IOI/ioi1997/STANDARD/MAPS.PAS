{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 65520,0,655360}
Program Maps (input , output);
Const  Mapsize             = 1000;{��ͼ�ߴ�}
       MaxN                = 1000;{������������}
       Inputname           = 'Maps.dat';{�����ļ���}
       outputname          = 'Maps.out';{����ļ���}
       Outname1            = 'outa.txt';{�����С���Ǽ�̰���㷨}
       outname2            = 'outb.txt';{�����������̰���㷨}

Type   Tpos                = record{����λ������}
                               x , y : integer;{��������}
                             end;
       TRect               = record{�ɷ���λ������}
                               num : Integer;{λ�����ڵĳ��к�}
                               lp , rp : TPos;{LP--���¶�����;RP--���϶�����}
                             end;
Var    RectSet             : Array[1 .. 4 * maxN] of Trect;{�ɷ��ñ�־λ�ñ�}
       Setlen              : Integer;{�ɷ���λ������}
       n                   : Integer;{������}

Procedure Initalize;{��ʼ������}
Var    fp                  : text;{�ļ�ָ��}
       i, j                : integer;{��������}
       getx , gety ,
       getw , geth , getl  : integer;{��������������Ϣ}
       namestr             : string;{������}
       center              : Array[1 .. maxn] of TPos;{��������λ�ñ�}

Function InMap (comlp , comrp : Tpos) : Boolean;
{�ж�Comlp-Comprp����λ���Ƿ��ڵ�ͼ��}
Begin
  inmap :=(comlp.x >=0) and (comlp.y >= 0)
          and (comrp.x < Mapsize) and (comrp.y < Mapsize){�ж�}
end; {InMap}

Procedure InSet (InNum , Inlpx , inlpy , inrpx , inrpy : Integer);
{���INNUM�ų��е�һ����ǩ�ɷ���λ��(Inlpx,Inlpy)-(inrpx,inrpy)�ڵ�ͼ����
�����RECSET��}
Var    nlp , nrp           : TPos;{��������}
Begin
  {�趨NLP,NRP}
  nlp.x :=inlpx; nlp.y :=inlpy;
  nrp.x :=inrpx; nrp.y :=inrpy;
  if InMap (nlp , nrp)
    then begin{�ж��Ƿ���MAP��}
           {����RECSET��}
           inc (setlen);
           With RectSet[setlen] do
             begin
               num :=InNum;
               lp :=nlp; rp :=nrp;
             end;
         end;
end; {InSet}

Procedure Swap (Var Rect1 ,Rect2 : TRect);{����RECT1,RECT2}
Var    tmp                 : TRect;{��������}
Begin
  tmp :=Rect1; Rect1 :=Rect2; Rect2 :=Tmp;{����}
end; {Swap}

Function Contain (ComPos , comlp , comrp: TPos) : Boolean;
{�ж���COMPOS�Ƿ��ھ���λ��COMLP-COMRP��}
begin
  contain :=(compos.x >=comlp.x) and (Compos.x <= comrp.x)
          and (compos.y >=comlp.y) and (Compos.y <= comrp.y);{�ж�}
end; {Contain}

Procedure Target (var oprstr : string);{�������OPRSTR�еĿո�ȥ��}
var    i                   : integer;{��������}
begin
  {ɾȥ���пո�}
  i :=Pos(' ' , oprstr);
  while i <> 0 do
    begin
      delete (oprstr , i , 1);
      i :=Pos(' ' , oprstr);
    end;
end; {Target}

Begin
  {����}
  Setlen :=0;
  Fillchar (RectSet , sizeof(RectSet) , 0);
  fillchar (center , sizeof(center) , 0);
  {�����ļ�}
  assign (fp , inputname);
  reset (fp);
  readln (fp , n);
  for i :=1 to n do
    begin
      readln (fp , getx , gety , getw , geth , namestr);{����һ��������Ϣ}
      target (namestr);{��NAMESTR�пո�ɾ��}
      getl :=length(namestr) + 1;{��ǩ�ַ���ΪNAMESTR����+1}
      {����ǰ������Χ�ĸ�ɷ���λ���ж��Ƿ���MAP��,��������λ������RECSET��}
      InSet (i , getx - getl*getw , gety + 1 , getx - 1 , gety + geth);
      InSet (i , getx - getl*getw , gety - geth , getx - 1 , gety - 1);
      InSet (i , getx + 1 , gety - geth , getx + getl*getw , gety - 1);
      InSet (i , getx + 1 , gety + 1 , getx + getl*getw , gety + geth);
      {��¼��������λ��}
      center[i].x :=getx; center[i].y :=gety;
    end;
  close (fp);
  {ȥ�����и��ǳ�������λ�õı�ǩ�ɷ���λ��}
  i :=1;
  While i <= Setlen do
    begin
      {�����г�������λ���ж��Ƿ񱻵�ǰ���θ���}
      j :=1;
      While (j <= n) and
        (not contain (center[j] , RectSet[i].lp , Rectset[i].rp))
      Do inc (j);
      if j <= n
        then begin{���ڱ����ǵĳ�������λ��}
               {����ǰλ���ڱ���ɾ��}
               Swap (rectSet[i] , Rectset[Setlen]);
               fillchar (rectset[setlen] ,sizeof(Rectset[setlen]) , 0);
               dec (Setlen);
             end
        else inc (i);{����,������һ��λ��}
    end;
end; {initalize}

Procedure Solve;{������}
Type   Arrtype = array[1 .. maxn * 4] of integer;{ͼ������Ϣ��������}
       AnsType = array[1 .. maxn * 4] of byte;{ѡ�������������}
Var    deg                 : ArrType;{������Ķ���}
       Ans1 , ans2         : anstype;{ANS1--�����С���Ǽ��ľ���;
                                      ANS2--������������ľ���;}
       selectn1 , selectn2 : integer;
       {SELECT1--�����С���Ǽ��ľ������������ǳ�����;
        SELECT2--������������ľ������������ǳ�����}

Function Min (com1 , com2 :integer) : integer;{MINΪCOM1,COM2�н�С��}
begin
  if com1 < com2
    then min :=com1
    else min :=com2;
end; {min}

Function max (com1 , com2 :integer) : integer;{MAXΪCOM1,COM2�нϴ���}
begin
  if com1 > com2
    then max :=com1
    else max :=com2;
end; {max}

Function Link (p1 , p2 : integer) : Boolean;
{�ж���P1,P2��λ���Ƿ��ͻ,����;�����ޱ�����}
Begin
  link :=(RectSet[p1].num = Rectset[p2].num){����ͬһ������} or
       ((max (RectSet[p1].lp.x , Rectset[p2].lp.x)
         <= min(Rectset[p1].rp.x , RectSet[p2].rp.x)) and
        (max (RectSet[p1].lp.y , Rectset[p2].lp.y)
         <= min(Rectset[p1].rp.y , RectSet[p2].rp.y)));{���������ཻ}
end; {Link}

Procedure GetDeg;{���㶥�����}
Var    i , j , k           : integer;{��������}
Begin
  {����}
  fillchar (Deg , sizeof(Deg) , 0);
  {�������}
  for i :=1 to Setlen do
    for j :=i + 1 to Setlen do
      if link (i , j){�ж����ޱ�}
      then
        begin{�ۻ�����}
          inc (deg[i]);
          inc (deg[j]);
        end;
end; {Getdeg}

Procedure Greedy1 (indeg : Arrtype; var reans : AnsType; var ren : integer);
{���ڶ���INDEG,���ͼ����С���Ǽ��õ�ѡ���ǩ�ľ���REANS,�������ɴ˵õ���
����ǳ�����REN}
Var    root , nextr        : Integer;{ROOT--��ǰѡ����븲�Ǽ��Ķ���;
                                      NEXTR-��һ��ѡ��Ķ���}
       i , j , k           : integer;{��������}
Begin
  {����}
  ren :=0;
  fillchar (reans , sizeof(reans) , 0);
  root :=0;
  {ѡ��������Ķ�����Ϊ��һ����С���Ǽ�Ԫ��}
  for i :=1 to setlen do
    if (root = 0) or (indeg[i] > indeg[root])
      then root :=i;
  While root <> 0 do{ѭ��ֱ�������ڶ�������0�ĵ�}
    begin
      {���߼�¼}
      inc (ren);
      reans[root] :=1;
      {ȥ��ROOT,�ı�ͼ�Ķ���,��ѡ����һ�ξ���}
      nextr :=0;
      for i :=1 to setlen do
        if (reans[i] = 0) and (indeg[i] > 0)
          then begin{����>0,����û�б�ѡ��}
                 if link (i , root){�ж��Ƿ���ROOT����}
                    then dec (indeg[i]);{������1}
                 if (indeg[i] > 0) and ((nextr = 0)
                 or (indeg[i] >  indeg[nextr])){�ж��Ƿ�Ϊ������}
                   then nextr :=i;{������һ�ξ���}
               end;
      root :=nextr;{�趨��ǰ���߶���}
    end;
  {��������=��С���Ǽ��Ĳ���}
  for i :=1 to setlen do
    begin
      reans[i] :=1 - reans[i];
    end;
  ren :=setlen - ren;
end; {Greedy1}

Procedure Printout (prans : Anstype; prn :integer;outname : string);
{�������PRANS�е�λ��,�ܹ������ߵĳ���ΪPRN,����ļ���ΪOUTNAME}
Var    fp                  : text;{�ļ�ָ��}
       i , j , k           : integer;{��������}
       prpos               : Array[1 .. maxn] of TPos;
       {��������趨��ǩ�����϶�����}
Begin
  {��PRPOS��ֵ����Ϊ-1}
  fillchar (prpos , sizeof(prpos) , $FF);
  {��PRANS����PRPOS}
  for i :=1 to setlen do
    if prans[i] = 1
      then begin{������}
             with RectSet[i] do
               begin{�趨PRPOS}
                 prpos[num].x :=lp.x;
                 prpos[num].y :=rp.y;
               end;
           end;
  {���}
  assign (fp , outname);
  rewrite (fp);
  for i :=1 to n do
    writeln (fp , prpos[i].x , ' ' ,prpos[i].y);{������϶�λ��}
  writeln ('Total number = ' , prn);{����Ļ�������ǩ�ĳ�������}
  close (fp);
end; {Printout}

Procedure Greedy2 (indeg : Arrtype; var reans : AnsType; var ren : integer);
{���ڶ���INDEG,�������������̰���㷨,��þ���REANS,���õ��ܱ�ǩ��ΪREN}
Var    root , nextr        : Integer;{ROOT--��ǰѡ�����������Ķ���;
                                      NEXTR-��һ��ѡ��Ķ���}
       i , j , k           : integer;{��������}
Begin
  {����}
  ren :=0;
  fillchar (reans , sizeof(reans) , 0);
  {��ö�����С�Ķ���Ϊ��һ��������Ԫ��}
  root :=0;
  for i :=1 to setlen do
    if (root = 0) or (indeg[i] < indeg[root])
      then root :=i;
  {̰�ľ���}
  While root <> 0 do{֪��û�п�ѡ��Ķ���}
    begin
      {��¼������Ϣ}
      inc (ren);
      reans[root] :=1;
      {����������Ϣ}
      for i :=1 to setlen do
        if (reans[i] = 0) and (indeg[i] > 0)
          then begin{��I���������ѡ��}
                 if link (i , root)
                    then Begin{��ROOT����}
                           reans[i] :=2;{�趨����ѡ��}
                           for j :=1 to setlen do
                             if (reans[j] = 0) and (indeg[j] > 0) and
                             link (i , j){��I����}
                               then dec (indeg[j]);{���ٶ���}
                         end;
               end;
      {ѡ����һ�ξ���}
      nextr :=0;
      for i :=1 to setlen do
        if (reans[i] = 0)
          and ((nextr = 0) or (indeg[i] < indeg[nextr]))
        then nextr :=i;{ѡȡ��ѡ��Ķ����ж�����С�Ķ���}
      root :=nextr;{ȷ����ǰ����}
    end;
end; {Greedy2}


Begin
  GetDeg;{�������}
(*  Greedy1 (deg , Ans1 , selectn1);*){�����С���Ǽ���̰���㷨}
{  Printout (ans1 , selectn1 , outname1);}
   Greedy2 (deg , Ans2 , selectn2);{�������������̰���㷨}
{  Printout (ans2 , selectn2 , outname2);}
(* if selectn1 > selectn2{ѡ�������㷨�еĽ��ŷ������}
    then Printout (ans1 , selectn1 , outputname)
    else*) Printout (ans2 , selectn2 , outputname)
End; {Solve}

Begin
  Initalize;{��ʼ��}
  Solve;{���}
end. {main}