function b = b_ChickFrazier(s)
if s<=1
    b= 0.233*s^2;
elseif s<=3
    b = 0.00537*s^4 - 0.06906*s^3+0.3167*s^2 -0.02326*s;
elseif s<40
    b=0.705*s^0.5*log(s);
else
    b=0.642*(s*(2*log(s))^1.4-log(32*pi))^0.5;
end