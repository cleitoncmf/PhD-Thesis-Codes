function y = f_Vdcn2c(Ceq,R,Rf,L,Lf,w,E0s,E0c,I0s,I0c,Icir0,Vdc0)
%% steady-state value of Vdcn2c

y = 0.0625d0.*(-32.0.*Ceq.*R.*w.*(E0c.*I0c - E0s.*I0s).*(36864.0.*Ceq ...
      .^2.*L.^2.*w.^4 + 2304.0.*Ceq.^2.*R.^2.*w.^2 - 384.0.*Ceq.*E0c.^2.*L.* ...
      w.^2 - 384.0.*Ceq.*E0s.^2.*L.*w.^2 - 1152.0.*Ceq.*L.*w.^2 + 2.0.* ...
      E0c.^4 + 4.0.*E0c.^2.*E0s.^2 + 6.0.*E0c.^2 + 2.0.*E0s.^4 + ...
      6.0.*E0s.^2 + 9.0) - (E0c.*I0s + E0s.*I0c).*(-1179648.0.*Ceq.^3.* ...
      L.^3.*w.^6 - 73728.0.*Ceq.^3.*L.*R.^2.*w.^4 + 61440.0.*Ceq.^2.*E0c.^ ...
      2.*L.^2.*w.^4 + 3072.0.*Ceq.^2.*E0c.^2.*R.^2.*w.^2 + 61440.0.*Ceq.^2 ...
      .*E0s.^2.*L.^2.*w.^4 + 3072.0.*Ceq.^2.*E0s.^2.*R.^2.*w.^2 + 110592.0 ...
      .*Ceq.^2.*L.^2.*w.^4 + 4608.0.*Ceq.^2.*R.^2.*w.^2 - 480.0.*Ceq.*E0c.^ ...
      4.*L.*w.^2 - 960.0.*Ceq.*E0c.^2.*E0s.^2.*L.*w.^2 - 2496.0.*Ceq.*E0c.^2 ...
      .*L.*w.^2 - 480.0.*Ceq.*E0s.^4.*L.*w.^2 - 2496.0.*Ceq.*E0s.^2.*L.*w.^2 ...
      - 2592.0.*Ceq.*L.*w.^2 + E0c.^6 + 3.0.*E0c.^4.*E0s.^2 + 9.0.*E0c ...
      .^4 + 3.0.*E0c.^2.*E0s.^4 + 18.0.*E0c.^2.*E0s.^2 + 24.0.*E0c.^2 ...
      + E0s.^6 + 9.0.*E0s.^4 + 24.0.*E0s.^2 + 18.0) + (E0c.*I0s + ...
      E0s.*I0c).*(37748736.0.*Ceq.^4.*L.^4.*w.^8 + 11796480.0.*Ceq.^4.*L.^ ...
      2.*R.^2.*w.^6 + 589824.0.*Ceq.^4.*R.^4.*w.^4 - 3538944.0.*Ceq.^3.* ...
      E0c.^2.*L.^3.*w.^6 - 294912.0.*Ceq.^3.*E0c.^2.*L.*R.^2.*w.^4 - ...
      3538944.0.*Ceq.^3.*E0s.^2.*L.^3.*w.^6 - 294912.0.*Ceq.^3.*E0s.^2.*L.* ...
      R.^2.*w.^4 - 4718592.0.*Ceq.^3.*L.^3.*w.^6 - 516096.0.*Ceq.^3.*L.*R ...
      .^2.*w.^4 + 95232.0.*Ceq.^2.*E0c.^4.*L.^2.*w.^4 + 4864.0.*Ceq.^2.* ...
      E0c.^4.*R.^2.*w.^2 + 190464.0.*Ceq.^2.*E0c.^2.*E0s.^2.*L.^2.*w.^4 + ...
      9728.0.*Ceq.^2.*E0c.^2.*E0s.^2.*R.^2.*w.^2 + 288768.0.*Ceq.^2.*E0c.^ ...
      2.*L.^2.*w.^4 + 10752.0.*Ceq.^2.*E0c.^2.*R.^2.*w.^2 + 95232.0.*Ceq.^ ...
      2.*E0s.^4.*L.^2.*w.^4 + 4864.0.*Ceq.^2.*E0s.^4.*R.^2.*w.^2 + ...
      288768.0.*Ceq.^2.*E0s.^2.*L.^2.*w.^4 + 10752.0.*Ceq.^2.*E0s.^2.*R.^2 ...
      .*w.^2 + 193536.0.*Ceq.^2.*L.^2.*w.^4 + 6912.0.*Ceq.^2.*R.^2.*w.^2 - ...
      576.0.*Ceq.*E0c.^6.*L.*w.^2 - 1728.0.*Ceq.*E0c.^4.*E0s.^2.*L.*w.^2 - ...
      3936.0.*Ceq.*E0c.^4.*L.*w.^2 - 1728.0.*Ceq.*E0c.^2.*E0s.^4.*L.*w.^2 - ...
      7872.0.*Ceq.*E0c.^2.*E0s.^2.*L.*w.^2 - 6720.0.*Ceq.*E0c.^2.*L.*w.^2 - ...
      576.0.*Ceq.*E0s.^6.*L.*w.^2 - 3936.0.*Ceq.*E0s.^4.*L.*w.^2 - 6720.0 ...
      .*Ceq.*E0s.^2.*L.*w.^2 - 3168.0.*Ceq.*L.*w.^2 + E0c.^8 + 4.0.*E0c.^6.* ...
      E0s.^2 + 11.0.*E0c.^6 + 6.0.*E0c.^4.*E0s.^4 + 33.0.*E0c.^4.*E0s ...
      .^2 + 39.0.*E0c.^4 + 4.0.*E0c.^2.*E0s.^6 + 33.0.*E0c.^2.*E0s.^4 ...
      + 78.0.*E0c.^2.*E0s.^2 + 48.0.*E0c.^2 + E0s.^8 + 11.0.*E0s.^6 + ...
      39.0.*E0s.^4 + 48.0.*E0s.^2 + 18.0) + 4.0.*(2.0.*E0c.*Icir0 ...
      - I0c).*(589824.0.*Ceq.^3.*E0c.*L.^2.*R.*w.^5 + 36864.0.*Ceq.^3.*E0c.* ...
      R.^3.*w.^3 - 1179648.0.*Ceq.^3.*E0s.*L.^3.*w.^6 - 73728.0.*Ceq.^3.* ...
      E0s.*L.*R.^2.*w.^4 - 6144.0.*Ceq.^2.*E0c.^3.*L.*R.*w.^3 + 61440.0.*Ceq ...
      .^2.*E0c.^2.*E0s.*L.^2.*w.^4 + 3072.0.*Ceq.^2.*E0c.^2.*E0s.*R.^2.*w.^2 - ...
      6144.0.*Ceq.^2.*E0c.*E0s.^2.*L.*R.*w.^3 - 18432.0.*Ceq.^2.*E0c.*L.*R.*w ...
      .^3 + 61440.0.*Ceq.^2.*E0s.^3.*L.^2.*w.^4 + 3072.0.*Ceq.^2.*E0s.^3.* ...
      R.^2.*w.^2 + 110592.0.*Ceq.^2.*E0s.*L.^2.*w.^4 + 4608.0.*Ceq.^2.*E0s ...
      .*R.^2.*w.^2 + 32.0.*Ceq.*E0c.^5.*R.*w - 480.0.*Ceq.*E0c.^4.*E0s.*L.*w.^ ...
      2 + 64.0.*Ceq.*E0c.^3.*E0s.^2.*R.*w + 96.0.*Ceq.*E0c.^3.*R.*w - ...
      960.0.*Ceq.*E0c.^2.*E0s.^3.*L.*w.^2 - 2496.0.*Ceq.*E0c.^2.*E0s.*L.*w.^2 ...
      + 32.0.*Ceq.*E0c.*E0s.^4.*R.*w + 96.0.*Ceq.*E0c.*E0s.^2.*R.*w + 144.0 ...
      .*Ceq.*E0c.*R.*w - 480.0.*Ceq.*E0s.^5.*L.*w.^2 - 2496.0.*Ceq.*E0s.^3.*L.* ...
      w.^2 - 2592.0.*Ceq.*E0s.*L.*w.^2 + E0c.^6.*E0s + 3.0.*E0c.^4.*E0s.^3 ...
      + 9.0.*E0c.^4.*E0s + 3.0.*E0c.^2.*E0s.^5 + 18.0.*E0c.^2.*E0s.^3 + ...
      24.0.*E0c.^2.*E0s + E0s.^7 + 9.0.*E0s.^5 + 24.0.*E0s.^3 + ...
      18.0.*E0s) + 4.0.*(2.0.*E0s.*Icir0 - I0s).*(-1179648.0.*Ceq.^3.* ...
      E0c.*L.^3.*w.^6 - 73728.0.*Ceq.^3.*E0c.*L.*R.^2.*w.^4 - 589824.0.*Ceq ...
      .^3.*E0s.*L.^2.*R.*w.^5 - 36864.0.*Ceq.^3.*E0s.*R.^3.*w.^3 + 61440.0.* ...
      Ceq.^2.*E0c.^3.*L.^2.*w.^4 + 3072.0.*Ceq.^2.*E0c.^3.*R.^2.*w.^2 + ...
      6144.0.*Ceq.^2.*E0c.^2.*E0s.*L.*R.*w.^3 + 61440.0.*Ceq.^2.*E0c.*E0s.^2 ...
      .*L.^2.*w.^4 + 3072.0.*Ceq.^2.*E0c.*E0s.^2.*R.^2.*w.^2 + 110592.0.* ...
      Ceq.^2.*E0c.*L.^2.*w.^4 + 4608.0.*Ceq.^2.*E0c.*R.^2.*w.^2 + 6144.0.* ...
      Ceq.^2.*E0s.^3.*L.*R.*w.^3 + 18432.0.*Ceq.^2.*E0s.*L.*R.*w.^3 - 480.0.* ...
      Ceq.*E0c.^5.*L.*w.^2 - 32.0.*Ceq.*E0c.^4.*E0s.*R.*w - 960.0.*Ceq.*E0c.^ ...
      3.*E0s.^2.*L.*w.^2 - 2496.0.*Ceq.*E0c.^3.*L.*w.^2 - 64.0.*Ceq.*E0c.^2.* ...
      E0s.^3.*R.*w - 96.0.*Ceq.*E0c.^2.*E0s.*R.*w - 480.0.*Ceq.*E0c.*E0s.^4.*L ...
      .*w.^2 - 2496.0.*Ceq.*E0c.*E0s.^2.*L.*w.^2 - 2592.0.*Ceq.*E0c.*L.*w.^2 ...
      - 32.0.*Ceq.*E0s.^5.*R.*w - 96.0.*Ceq.*E0s.^3.*R.*w - 144.0.*Ceq.*E0s ...
      .*R.*w + E0c.^7 + 3.0.*E0c.^5.*E0s.^2 + 9.0.*E0c.^5 + 3.0.*E0c.^3 ...
      .*E0s.^4 + 18.0.*E0c.^3.*E0s.^2 + 24.0.*E0c.^3 + E0c.*E0s.^6 + ...
      9.0.*E0c.*E0s.^4 + 24.0.*E0c.*E0s.^2 + 18.0.*E0c))./(Ceq.*w.*( ...
      37748736.0.*Ceq.^4.*L.^4.*w.^8 + 11796480.0.*Ceq.^4.*L.^2.*R.^2.*w.^ ...
      6 + 589824.0.*Ceq.^4.*R.^4.*w.^4 - 3538944.0.*Ceq.^3.*E0c.^2.*L.^3.* ...
      w.^6 - 294912.0.*Ceq.^3.*E0c.^2.*L.*R.^2.*w.^4 - 3538944.0.*Ceq.^3.* ...
      E0s.^2.*L.^3.*w.^6 - 294912.0.*Ceq.^3.*E0s.^2.*L.*R.^2.*w.^4 - ...
      5898240.0.*Ceq.^3.*L.^3.*w.^6 - 589824.0.*Ceq.^3.*L.*R.^2.*w.^4 + ...
      95232.0.*Ceq.^2.*E0c.^4.*L.^2.*w.^4 + 4864.0.*Ceq.^2.*E0c.^4.*R.^2.*w ...
      .^2 + 190464.0.*Ceq.^2.*E0c.^2.*E0s.^2.*L.^2.*w.^4 + 9728.0.*Ceq.^2 ...
      .*E0c.^2.*E0s.^2.*R.^2.*w.^2 + 350208.0.*Ceq.^2.*E0c.^2.*L.^2.*w.^4 + ...
      13824.0.*Ceq.^2.*E0c.^2.*R.^2.*w.^2 + 95232.0.*Ceq.^2.*E0s.^4.*L.^2.* ...
      w.^4 + 4864.0.*Ceq.^2.*E0s.^4.*R.^2.*w.^2 + 350208.0.*Ceq.^2.*E0s.^ ...
      2.*L.^2.*w.^4 + 13824.0.*Ceq.^2.*E0s.^2.*R.^2.*w.^2 + 304128.0.*Ceq ...
      .^2.*L.^2.*w.^4 + 11520.0.*Ceq.^2.*R.^2.*w.^2 - 576.0.*Ceq.*E0c.^6.*L ...
      .*w.^2 - 1728.0.*Ceq.*E0c.^4.*E0s.^2.*L.*w.^2 - 4416.0.*Ceq.*E0c.^4.*L ...
      .*w.^2 - 1728.0.*Ceq.*E0c.^2.*E0s.^4.*L.*w.^2 - 8832.0.*Ceq.*E0c.^2.* ...
      E0s.^2.*L.*w.^2 - 9216.0.*Ceq.*E0c.^2.*L.*w.^2 - 576.0.*Ceq.*E0s.^6.*L ...
      .*w.^2 - 4416.0.*Ceq.*E0s.^4.*L.*w.^2 - 9216.0.*Ceq.*E0s.^2.*L.*w.^2 - ...
      5760.0.*Ceq.*L.*w.^2 + E0c.^8 + 4.0.*E0c.^6.*E0s.^2 + 12.0.*E0c.^ ...
      6 + 6.0.*E0c.^4.*E0s.^4 + 36.0.*E0c.^4.*E0s.^2 + 48.0.*E0c.^4 + ...
      4.0.*E0c.^2.*E0s.^6 + 36.0.*E0c.^2.*E0s.^4 + 96.0.*E0c.^2.*E0s.^2 ...
      + 72.0.*E0c.^2 + E0s.^8 + 12.0.*E0s.^6 + 48.0.*E0s.^4 + 72.0 ...
      .*E0s.^2 + 36.0));