function [cost, grad] = softmaxCost(theta, numClasses, inputSize, rho, inputData, lab,z,u)
% softmaxCost Calculate the likelihood of multivariate logistic regression

% numClasses - the number of classes 
% inputSize - the size N of the input vector
% lambda - weight decay parameter
% data - the N x M input matrix, where each column data(:, i) corresponds to
%        a single test set
% labels - an M x 1 matrix containing the labels corresponding for the input data
%

% Unroll the parameters from theta
theta_old=theta;

theta = reshape(theta, numClasses, inputSize);
%inputData
numCases = size(inputData, 2);

groundTruth = full(sparse(lab, 1:numCases, 1));
cost = 0;

thetagrad = zeros(numClasses, inputSize);

%% ---------- YOUR CODE HERE --------------------------------------
%  Instructions: Compute the cost and gradient for softmax regression.
%                You need to compute thetagrad and cost.
%                The groundTruth matrix might come in handy.
size(theta);
size(inputData);

M = bsxfun(@minus,theta*inputData,max(theta*inputData, [], 1));  %减去theta*data中结果数值最大的数，首先由于softmax模型过度参数化，参数减去一个常数多结果没有影响（详细探讨见andrew ng教程）；
                                                       %其次，由于要对参数进行指数exp的计算，可能由于为了防止指数的值过大，所以减去一个最大的结果。
M = exp(M);
p = bsxfun(@rdivide, M, sum(M));
ab=theta_old-z+u;
cost = -1/numCases * groundTruth(:)' * log(p(:)) + rho/2 * sum(ab(:).^ 2);
g = reshape(ab, numClasses, inputSize);
thetagrad = -1/numCases * (groundTruth - p) * inputData' + rho * g;





% ------------------------------------------------------------------
% Unroll the gradient matrices into a vector for minFunc
grad = [thetagrad(:)];
end

