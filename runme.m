clear all
clc
close all

%% Import the data
workbookFile = 'Inductor.xlsx';
sheetName = 'E498x008';
f_HP=logspace(log10(20), log10(1e6), 201);
Sirio_HP = importfileHP_excel(workbookFile,'E498x008');
Simon_HP = importfileHP_excel(workbookFile,'E498x007');
Kaschke_HP = importfileHP_excel(workbookFile,'E498x006');
Sirio_WK = importfileWK_excel(workbookFile,'sirio');
Simon_WK = importfileWK_excel(workbookFile,'simon');
Kaschke_WK = importfileWK_excel(workbookFile,'kaschke');

%% RDC measured with voltmeter
Sirio_Rdc=89.9e-3/4.88*ones(size(f_HP));
Simon_Rdc=87.43e-3/4.83*ones(size(f_HP));
Kaschke_Rdc=41e-3/4.55*ones(size(f_HP));

%% merge meas
f_new=logspace(1,7,1000);
Sirio_Rdc_new=interp1(f_HP, Sirio_Rdc, f_new,'linear','extrap');
Sirio_Rac_new=interp1(Sirio_WK.f, Sirio_WK.Rs, f_new,'linear','extrap');
Sirio_Ls_new=interp1(Simon_WK.f, Sirio_WK.Ls, f_new);
Sirio_Rac=max(Sirio_Rdc_new, Sirio_Rac_new);

Simon_Rdc_new=interp1(f_HP, Simon_Rdc, f_new,'linear','extrap');
Simon_Rac_new=interp1(Simon_WK.f, Simon_WK.Rs, f_new,'linear','extrap');
Simon_Ls_new=interp1(Simon_WK.f, Simon_WK.Ls, f_new,'linear','extrap');
Simon_Rac=max(Simon_Rdc_new, Simon_Rac_new);

Kaschke_Rdc_new=interp1(f_HP, Kaschke_Rdc, f_new,'linear','extrap');
Kaschke_Rac_new=interp1(Kaschke_WK.f, Kaschke_WK.Rs, f_new,'linear','extrap');
Kaschke_Ls_new=interp1(Kaschke_WK.f, Kaschke_WK.Ls, f_new,'linear','extrap');
Kaschke_Rac=max(Kaschke_Rdc_new, Kaschke_Rac_new);

% %% plot
% figure
% loglog(f_HP, Sirio_HP.Rs, 'DisplayName','Sirio_HP')
% hold on
% loglog(f_HP, Simon_HP.Rs, 'DisplayName','Simon_HP')
% loglog(f_HP, Kaschke_HP.Rs, 'DisplayName','Kaschke_HP')
% 
% loglog(f_HP, Sirio_Rdc, 'DisplayName','Sirio_Rdc')
% hold on
% loglog(f_HP, Simon_Rdc, 'DisplayName','Simon_Rdc')
% loglog(f_HP, Kaschke_Rdc, 'DisplayName','Kaschke_Rdc')
% 
% loglog(Sirio_WK.f, Sirio_WK.Rs, 'DisplayName','Sirio_WK')
% loglog(Simon_WK.f, Simon_WK.Rs, 'DisplayName','Simon_WK')
% loglog(Kaschke_WK.f, Kaschke_WK.Rs, 'DisplayName','Kaschke_WK')
% title('Rdc/Rac separated per instrument to debug measurement problems')
% xlabel('f'); ylabel('Rac')
% % grid on; l=legend; set(l, 'Interpreter', 'none', 'Location','southwest');
% % hold on
% l=legend; 
% set(l, 'Interpreter', 'none', 'Location','northwest');
% grid on

%% fitting optim
Zm_Re = Simon_Rac_new;
Zm_Im = 2*pi*f_new.*Simon_Ls_new;
Zm_abs = abs(Zm_Re+1j.*Zm_Im);

N=length(f_new);

Rs_L1	= 9;    % in mOhm
L1      = 50;    % in uH
Rp_L1   = 100;         % in Ohm
C1      = 100;    % in pF

% optimization vars
x0=[Rs_L1; L1; Rp_L1; C1];
xs=[15, 100, 1e+04, 10]
sprintf( 'x=[%e, %e, %e, %e]', x0(1),x0(2),x0(3),x0(4))

lb=[5;    100;    10e3;    5];
ub=[12;     200;    10e4;   10];
% xs=[1.000000e+01, 1.001799e+03, 6.147135e+01, 8.612721e+02, 2.012547e+04]
%x0=xs;

% Constraints in Zi
Zeq_up       = 1e5*ones(1,N);
Zeq_low      = 1e-3*ones(1,N);

fun = @(x,f_new)f_Zeq(x,f_new);
xs = lsqcurvefit(fun,x0,f_new,Zm_Re,lb,ub);

Zeq_x0_real = f_Zeq(x0, f_new );
Zeq_xs_real = f_Zeq(xs, f_new );
figure(1);
loglog(f_new,Zeq_x0_real, 'DisplayName','Zeq_nofit_abs')
hold on;
loglog(f_new,Zm_Re, 'DisplayName','Zm_Re');
loglog(f_new,Zeq_xs_real, 'DisplayName','Zeq_fit_abs')
l=legend; set(l, 'Interpreter', 'none', 'Location','best');
grid on; xlabel('f_new'); ylabel('Zeq abs');
hold off;

sprintf( 'x=[%e, %e, %e, %e]', xs(1),xs(2),xs(3),xs(4))
