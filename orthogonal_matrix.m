function [ answer ] = orthogonal_matrix( A )
[Q,D] = eig(A);
leng = size(Q);
len = leng(1);
A = [];
for n = 1:len
    n_evector = Q(:,n)/D(n,n);
    A = [A, n_evector];
answer = A;
end

