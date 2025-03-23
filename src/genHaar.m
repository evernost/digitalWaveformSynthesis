function H = genHaar(N)

  p = [0 0];
  q = [0 1];
  n = nextpow2(N);

  for i = 1:(n-1)
    p = [p i*ones(1,2^i)];
    t = 1:(2^i);
    q = [q t];
  end
  
  H = zeros(N);
  H(1,:) = 1;
  
  for i = 2:N
    P = p(1,i); Q = q(1,i);
    for j = (N*(Q-1)/(2^P)):(N*((Q-0.5)/(2^P))-1)
      H(i,j+1) = 2^(P/2);
    end
    
    for j= (N*((Q-0.5)/(2^P))):(N*(Q/(2^P))-1)
      H(i,j+1) = -(2^(P/2));
    end
  end
  H = H*(1/sqrt(N));
  
end

