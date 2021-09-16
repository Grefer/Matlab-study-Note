function p = LSM(S0,X,T,r,sigma,nStep,nPath)
    s = sPath(S0,r,sigma,T,nStep,nPath);
    [nPath,nStep] = size(s);
    nStep = nStep -1;
    dt = T/nStep;
    cashflow = zeros(size(s));
    cashflow(:,end) = max(100*s(:,end)/X-102,0);
    mtime = (nStep + 1)*ones(1,nPath);
    for j = size(s,2)-1:-1:2
        cashflow(:,j) = max(100*s(:,j)/X-102,0);
        m = find(cashflow(:,j) > 0);
        cf = cashflow(j+1,m);
        v = cf.*(exp(-r * dt));
        s = s(j,m);
        md = fitlm(s,v,'purequadratic');
        fun = @(x) (md.Coefficients.Estimate(1) + md.Coefficients.Estimate(2) .* x ...
            +md.Coefficients.Estimate(3) .* x .^ 2);
        HV = fun(s);
        m1 = cashflow(j,m) > HV;
        cashflow(j+1:end,m(m1)) = 0;
        n = setdiff(1:nPath,m(m1));
        cashflow(j,n) = cashflow(j+1,n) .* exp(-r * dt);
        mtime(m(m1)) = j;
    end

    for j =  1:nPath
        cashflow(1:j) = cashflow(mtime(j),j) * exp(-r * (mtime(j) - 1)* dt);
    end
    p = mean(cashflow(1,:));
end
