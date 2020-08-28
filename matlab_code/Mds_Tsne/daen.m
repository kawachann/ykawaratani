function X=daen(mu,S,q)

s2=diag(S);
rho=S(1,2)/prod(sqrt(s2));

D2=-2*log(1-q/100);
p=1/(2*pi*sqrt(det(S)))*exp(-1/2*D2);
C=-2*log(2*pi*sqrt(det(S))*p);
t=(0:360).';
P=1/sqrt(2)*[1 -1;1 1];
tmpy1=cosd(t)*sqrt(C*(1+rho));
tmpy2=sind(t)*sqrt(C*(1-rho));

[R,~]=size(mu);
if R==length(mu)
 tmp=mu;
else
 tmp=mu.';
end

X=bsxfun(@plus,sqrt(diag(s2))*P*[tmpy1.';tmpy2.'],tmp).';