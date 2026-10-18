def bilinear(v00, v01, v10, v11, x, y, x_bounds, y_bounds):
    
    x0, x1 = x_bounds
    y0, y1 = y_bounds

    fx = (x - x0) / (x1 - x0)
    fy = (y - y0) / (y1 - y0)

    r0 = v00 + fy * (v01 - v00)
    r1 = v10 + fy * (v11 - v10)
    return r0 + fx * (r1 - r0)


def main():

    v00 = 0.0406096
    v01 = 0.128774
    v10 = 0.0598324
    v11 = 0.166797

    x = 0.03      
    y = 0.05   

    x_bounds = (0.0186, 0.0966)  
    y_bounds = (0.039, 0.0648)

    delay = bilinear(v00, v01, v10, v11, x, y, x_bounds, y_bounds)
    print(f"Otvet = {delay:.6f} ")


if __name__ == "__main__":
    main()