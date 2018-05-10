						
						 % -------
           				 %| IUPad | 
           				 % -------
            
%---------------------------------------------------------------------          
%Interface Utilisateur Partial Dérivatives ( dérivées partielles ) :
%    - permet d'étudier la sensibilité des inputs
%    - méthode proposé par Yannis Dimopoulos
%---------------------------------------------------------------------

Z=Z; %pour ne pas dépasser la zone d'inscription de l'aide

%*************************Calcule des derivées partielles************************
ab=[]; res=[]; dd=[];

A1p=logsig(W1*P,B1);
A2p=logsig(W2*A1p,B2);
D=A2p.*(1-A2p);%on calcule la derivée de A2

sdb=[]; ssd=0;

for k=1:R,   %neurones d'entrée
   for i=1:S2,   %neurones de sortie
      result=0;
      derivee=0;
      for j=1:S1,  %neurones de couche cachée
         result=result+(W2(i,j)*(A1p(j,:).*(1-A1p(j,:)))*W1(j,k));
      end
      derivee=D(i,:).*result;%on calcule la derivée partielle pour un paramètre
      ab=[ab; data(1:Appr,k)];
      dd=[dd ;derivee];
      res=[res data(1:Appr,k) (derivee')];
      for h=1:Q
         ssd=ssd+(derivee(h)^2);%calcul de la sensibilité pour chaque paramètre
      end 
      sdb=[sdb ;ssd];
      ssd=0;
   end
   
end  

%% Loren's notes

% It looks like they start with the derivative of logsig, then calculate
% the derivative of each output neuron with respect to each input neuron.

% My guess at variable definitions:
%
% Z = ? (I don't understand why to define Z = Z)
% P = input matrix?
% W1 = matrix of weights from inputs to hidden layer nodes?
% W2 = matrix of weights from hidden layer nodes to outputs?
% B1 = bias for first layer?  But why isn't it added to inputs*weights?
% B2 = bias for second layer?  But why isn't it added first_layer_outputs*weights?
% R = number of input neurons?
% S1 = number of hidden layer neurons?
% S2 = number of output neurons?
% h = something to do with the gradient vector
% ssd = sum of square derivatives.  See Gevrey 2006 page 45.
% derivee = partial derivative
% Appr = ?
% Q = ?
% ab, res, dd and sbd are all calculated in this script, but I haven't yet
% figured out what they stand for
