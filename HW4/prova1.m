clear all; close all; clc;

load('generated_symbols.mat','a')

x = OFDM_TXCH(a, 10, 54, 2);