function [fiInit,E,T] = normalize_HMM(fiInit_tmp,E_tmp,T_tmp,offset)
    E_tmp = E_tmp+offset;
    E = E_tmp*diag(1./(sum(E_tmp,1)));
    T = diag(1./(sum(T_tmp,2)+offset))*T_tmp;
    fiInit = fiInit_tmp/sum(fiInit_tmp);