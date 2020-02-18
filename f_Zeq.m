% function [Zeq_Re, Zeq_Im] = f_Zeq(x,f )
function [Zeq_Re] = f_Zeq_real(x,f )
Rs_L1	= x(1)*1e-3;    % in mOhm
L1      = x(2)*1e-6;    % in uH
Rp_L1   = x(3);         % in Ohm
C1      = x(4)*1e-12;    % in pF

% preprocessing
s       = 1i*2*pi*f;
ZC1 = 1./s/C1;
ZL1 = 1./(1./(Rs_L1+s.*L1)+1./Rp_L1);
Zeq=ZL1.*ZC1./(ZL1+ZC1);
Zeq_Re = real(Zeq);
Zeq_Im = imag(Zeq);
Zeq_abs = abs(Zeq);

% output


% % debug
% loglog(f, abs(ZL1), 'DisplayName','ZL1');
% hold on; 
% loglog(f, abs(ZC1), 'DisplayName','ZC1');
% loglog(f, abs(Zeq), 'DisplayName','Zeq');
% l=legend; set(l, 'Interpreter', 'none', 'Location','best');
% grid on; xlabel('f'); ylabel('Zx_abs');
% hold off;
% 

end

