function y = f_Vdcn4c(Ceq,R,Rf,L,Lf,w,E0s,E0c,I0s,I0c,Icir0,Vdc0)
%% steady-state value of Vdcn4c


y = 0.06250.*(2.0.*(E0c.*I0c - E0s.*I0s).*(-2304.0.*Ceq.^2.*E0c.^2.* ...
      L.*R.*w.^3 + 6144.0.*Ceq.^2.*E0c.*E0s.*L.^2.*w.^4 - 768.0.*Ceq.^2.*E0c ...
      .*E0s.*R.^2.*w.^2 + 2304.0.*Ceq.^2.*E0s.^2.*L.*R.*w.^3 + 40.0.*Ceq.*E0c ...
      .^4.*R.*w - 288.0.*Ceq.*E0c.^3.*E0s.*L.*w.^2 + 72.0.*Ceq.*E0c.^2.*R.*w - ...
      288.0.*Ceq.*E0c.*E0s.^3.*L.*w.^2 - 480.0.*Ceq.*E0c.*E0s.*L.*w.^2 - ...
      40.0.*Ceq.*E0s.^4.*R.*w - 72.0.*Ceq.*E0s.^2.*R.*w + E0c.^5.*E0s + ...
      2.0.*E0c.^3.*E0s.^3 + 6.0.*E0c.^3.*E0s + E0c.*E0s.^5 + 6.0.*E0c.* ...
      E0s.^3 + 6.0.*E0c.*E0s) - (E0c.*I0s + E0s.*I0c).*(-6144.0.*Ceq.^2.* ...
      E0c.^2.*L.^2.*w.^4 + 768.0.*Ceq.^2.*E0c.^2.*R.^2.*w.^2 - 9216.0.*Ceq ...
      .^2.*E0c.*E0s.*L.*R.*w.^3 + 6144.0.*Ceq.^2.*E0s.^2.*L.^2.*w.^4 - 768.0 ...
      .*Ceq.^2.*E0s.^2.*R.^2.*w.^2 + 288.0.*Ceq.*E0c.^4.*L.*w.^2 + 160.0.* ...
      Ceq.*E0c.^3.*E0s.*R.*w + 480.0.*Ceq.*E0c.^2.*L.*w.^2 + 160.0.*Ceq.*E0c.* ...
      E0s.^3.*R.*w + 288.0.*Ceq.*E0c.*E0s.*R.*w - 288.0.*Ceq.*E0s.^4.*L.*w.^2 ...
      - 480.0.*Ceq.*E0s.^2.*L.*w.^2 - E0c.^6 - E0c.^4.*E0s.^2 - 6.0.*E0c ...
      .^4 + E0c.^2.*E0s.^4 - 6.0.*E0c.^2 + E0s.^6 + 6.0.*E0s.^4 + ...
      6.0.*E0s.^2) - 2.0.*(2.0.*E0c.*Icir0 - I0c).*(-4608.0.*Ceq.^2.* ...
      E0c.^3.*L.*R.*w.^3 + 18432.0.*Ceq.^2.*E0c.^2.*E0s.*L.^2.*w.^4 - ...
      2304.0.*Ceq.^2.*E0c.^2.*E0s.*R.^2.*w.^2 + 13824.0.*Ceq.^2.*E0c.*E0s.^ ...
      2.*L.*R.*w.^3 - 6144.0.*Ceq.^2.*E0s.^3.*L.^2.*w.^4 + 768.0.*Ceq.^2.* ...
      E0s.^3.*R.^2.*w.^2 + 80.0.*Ceq.*E0c.^5.*R.*w - 864.0.*Ceq.*E0c.^4.*E0s ...
      .*L.*w.^2 - 160.0.*Ceq.*E0c.^3.*E0s.^2.*R.*w + 144.0.*Ceq.*E0c.^3.*R.*w ...
      - 576.0.*Ceq.*E0c.^2.*E0s.^3.*L.*w.^2 - 1440.0.*Ceq.*E0c.^2.*E0s.*L.*w ...
      .^2 - 240.0.*Ceq.*E0c.*E0s.^4.*R.*w - 432.0.*Ceq.*E0c.*E0s.^2.*R.*w + ...
      288.0.*Ceq.*E0s.^5.*L.*w.^2 + 480.0.*Ceq.*E0s.^3.*L.*w.^2 + 3.0.*E0c ...
      .^6.*E0s + 5.0.*E0c.^4.*E0s.^3 + 18.0.*E0c.^4.*E0s + E0c.^2.*E0s.^5 ...
      + 12.0.*E0c.^2.*E0s.^3 + 18.0.*E0c.^2.*E0s - E0s.^7 - 6.0.*E0s.^ ...
      5 - 6.0.*E0s.^3) + 2.0.*(2.0.*E0s.*Icir0 - I0s).*(-6144.0.*Ceq ...
      .^2.*E0c.^3.*L.^2.*w.^4 + 768.0.*Ceq.^2.*E0c.^3.*R.^2.*w.^2 - ...
      13824.0.*Ceq.^2.*E0c.^2.*E0s.*L.*R.*w.^3 + 18432.0.*Ceq.^2.*E0c.*E0s.^ ...
      2.*L.^2.*w.^4 - 2304.0.*Ceq.^2.*E0c.*E0s.^2.*R.^2.*w.^2 + 4608.0.*Ceq ...
      .^2.*E0s.^3.*L.*R.*w.^3 + 288.0.*Ceq.*E0c.^5.*L.*w.^2 + 240.0.*Ceq.*E0c ...
      .^4.*E0s.*R.*w - 576.0.*Ceq.*E0c.^3.*E0s.^2.*L.*w.^2 + 480.0.*Ceq.*E0c ...
      .^3.*L.*w.^2 + 160.0.*Ceq.*E0c.^2.*E0s.^3.*R.*w + 432.0.*Ceq.*E0c.^2.* ...
      E0s.*R.*w - 864.0.*Ceq.*E0c.*E0s.^4.*L.*w.^2 - 1440.0.*Ceq.*E0c.*E0s.^2 ...
      .*L.*w.^2 - 80.0.*Ceq.*E0s.^5.*R.*w - 144.0.*Ceq.*E0s.^3.*R.*w - E0c.^7 ...
      + E0c.^5.*E0s.^2 - 6.0.*E0c.^5 + 5.0.*E0c.^3.*E0s.^4 + 12.0.*E0c ...
      .^3.*E0s.^2 - 6.0.*E0c.^3 + 3.0.*E0c.*E0s.^6 + 18.0.*E0c.*E0s.^4 ...
      + 18.0.*E0c.*E0s.^2))./(Ceq.*w.*(37748736.0.*Ceq.^4.*L.^4.*w.^8 + ...
      11796480.0.*Ceq.^4.*L.^2.*R.^2.*w.^6 + 589824.0.*Ceq.^4.*R.^4.*w.^4 ...
      - 3538944.0.*Ceq.^3.*E0c.^2.*L.^3.*w.^6 - 294912.0.*Ceq.^3.*E0c.^2.* ...
      L.*R.^2.*w.^4 - 3538944.0.*Ceq.^3.*E0s.^2.*L.^3.*w.^6 - 294912.0.* ...
      Ceq.^3.*E0s.^2.*L.*R.^2.*w.^4 - 5898240.0.*Ceq.^3.*L.^3.*w.^6 - ...
      589824.0.*Ceq.^3.*L.*R.^2.*w.^4 + 95232.0.*Ceq.^2.*E0c.^4.*L.^2.*w.^4 ...
      + 4864.0.*Ceq.^2.*E0c.^4.*R.^2.*w.^2 + 190464.0.*Ceq.^2.*E0c.^2.*E0s ...
      .^2.*L.^2.*w.^4 + 9728.0.*Ceq.^2.*E0c.^2.*E0s.^2.*R.^2.*w.^2 + ...
      350208.0.*Ceq.^2.*E0c.^2.*L.^2.*w.^4 + 13824.0.*Ceq.^2.*E0c.^2.*R.^2 ...
      .*w.^2 + 95232.0.*Ceq.^2.*E0s.^4.*L.^2.*w.^4 + 4864.0.*Ceq.^2.*E0s.^ ...
      4.*R.^2.*w.^2 + 350208.0.*Ceq.^2.*E0s.^2.*L.^2.*w.^4 + 13824.0.*Ceq ...
      .^2.*E0s.^2.*R.^2.*w.^2 + 304128.0.*Ceq.^2.*L.^2.*w.^4 + 11520.0.* ...
      Ceq.^2.*R.^2.*w.^2 - 576.0.*Ceq.*E0c.^6.*L.*w.^2 - 1728.0.*Ceq.*E0c.^ ...
      4.*E0s.^2.*L.*w.^2 - 4416.0.*Ceq.*E0c.^4.*L.*w.^2 - 1728.0.*Ceq.*E0c.^ ...
      2.*E0s.^4.*L.*w.^2 - 8832.0.*Ceq.*E0c.^2.*E0s.^2.*L.*w.^2 - 9216.0.* ...
      Ceq.*E0c.^2.*L.*w.^2 - 576.0.*Ceq.*E0s.^6.*L.*w.^2 - 4416.0.*Ceq.*E0s ...
      .^4.*L.*w.^2 - 9216.0.*Ceq.*E0s.^2.*L.*w.^2 - 5760.0.*Ceq.*L.*w.^2 + ...
      E0c.^8 + 4.0.*E0c.^6.*E0s.^2 + 12.0.*E0c.^6 + 6.0.*E0c.^4.*E0s.^ ...
      4 + 36.0.*E0c.^4.*E0s.^2 + 48.0.*E0c.^4 + 4.0.*E0c.^2.*E0s.^6 + ...
      36.0.*E0c.^2.*E0s.^4 + 96.0.*E0c.^2.*E0s.^2 + 72.0.*E0c.^2 + E0s ...
      .^8 + 12.0.*E0s.^6 + 48.0.*E0s.^4 + 72.0.*E0s.^2 + 36.0));