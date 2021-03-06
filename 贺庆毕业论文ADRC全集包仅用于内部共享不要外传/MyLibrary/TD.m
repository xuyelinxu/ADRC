function [sys,x0,str,ts] = TD(t,x,u,flag,r0,h)
%函数声明,“TD”为S-函数的名称，可换成期望的函数名
%t为当前仿真时间，x为状态向量，u为输入向量，flag用以标示S-函数当前所处的仿真步骤，以便执行相应的回调
switch flag,
  case 0 % 初始化
    [sys,x0,str,ts] = mdlInitializeSizes(h);
  case 2 % 离散状态的更新
    sys = mdlUpdates( x,u,r0,h);
  case 3 % 计算输出信号
    sys = mdlOutputs(x);
  case {1,4,9} % 不需要的值
    sys = [];
otherwise % 错误处理
    error( ['unhandled flag = ',num2str( flag) ]) ;
end;
% ＊＊＊＊＊＊＊＊＊flag = 0， 整个系统的初始化＊＊＊＊＊＊＊＊＊
function [sys,x0,str,ts] = mdlInitializeSizes(h)
    sizes = simsizes; % 创建结构 sizes
% 用初始化信息填充结构 sizes
    sizes.NumContStates = 0; % 连续状态变量 0 个
    sizes.NumDiscStates = 2; % 离散状态变量 2 个
    sizes.NumOutputs = 2; % 输出变量 2 个
    sizes.NumInputs = 1; % 输入变量 1 个
    sizes.DirFeedthrough = 0; % 输出中不含输入量
    sizes.NumSampleTimes = 1; % 模块采样周期的个数
    sys = simsizes( sizes) ; % 对系统参数初始化
    x0 = [0; 0]; % 设置初始状态
    str = []; % 备用变量定义为空矩阵
    ts = [h 0]; % 继承输入的采样周期
% ＊＊＊＊＊＊＊flag = 2， 更新离散系统状态变量 ＊＊＊＊＊＊
function sys = mdlUpdates( x,u,r0,h)
    sys(1,1) = x(1) + h* x(2) ;
    sys(2,1) = x(2) + h* fhan(x(1)-u,x(2),r0,h);
% ＊＊＊＊＊＊＊＊＊＊＊flag = 3， 计算输出量 ＊＊＊＊＊＊＊＊＊＊＊
function sys = mdlOutputs( x)
    sys = x;
function y=fhan(x1,x2,r,h)
d=r*h;
d0=h*d;
y=x1+h*x2;
a0=sqrt(d^2+8*r*abs(y));
if abs(y)>d0
    a=x2+(a0-d)*sign(y)/2;
else
    a=x2+y/h;
end

if abs(a)>d
    y=-r*sign(a);
else 
    y=-r*a/d;
end