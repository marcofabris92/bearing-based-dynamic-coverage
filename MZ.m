function exeption = MZ(i,k,h,j,Nk,storage,counter,exeption)

global A P epsilon

if exeption
    return
end

p_k = P(k,:);
p_h = P(h,:);
ang_a = computeAngle(P(i,:),p_k,p_h);
if isempty(ang_a) || sign(A) ~= sign(ang_a) || abs(ang_a) > abs(A)
    return
end

storage = storage+ang_a;
counter = counter+1;
ang_b = computeAngle(p_h,p_k,P(j,:));
if counter > 1 && ~(isempty(ang_b) || sign(A) ~= sign(ang_b) ||...
        abs(ang_b) > abs(A)) && abs(storage+ang_b-A) < epsilon
    exeption = 1;
end

Nk = Nk(Nk~=h);
t = 0;
while t < length(Nk) && ~exeption
    t = t+1;
    exeption = MZ(h,k,Nk(t),j,Nk,storage,counter,exeption);
end

end