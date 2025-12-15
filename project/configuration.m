%% Default
close all;
clear all;
clc;

%% Desired trajectory
t = linspace(0, 100, 100000);
radius = 5;
omega_des = 2;
x_des = radius*cos(omega_des*t);
y_des = radius*sin(omega_des*t);