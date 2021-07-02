function L = LogMat(n,allS)
%% downloaded form https://github.com/jrriehl/FindEQ/blob/master/eq/LogMat.m

% Generate logical matrix containing all possible configurations of n
% strategy states as rows of the matrix

% Example: LogMat(2,[-1;1]) has four rows and 2 colums, where each row is a
% unique combination of -1 and 1

ns = length(allS);

L = zeros(ns^n,n);
for i = 1:n
  q = allS;
  for j = 1:n-i
    q = kron(q,ones(size(allS)));
  end
  L(:,i) = repmat(q,ns^(i-1),1);
end