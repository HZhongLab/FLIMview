function ROI_siz = FV_getROISize(value)

switch value
    case {1, 9}
        ROI_siz = 16;
    case {2}
        ROI_siz = 1;
    case {3}
        ROI_siz = 2;
    case {4}
        ROI_siz = 3;
    case {5}
        ROI_siz = 5;
    case {6}
        ROI_siz = 7;
    case {7}
        ROI_siz = 10;
    case {8}
        ROI_siz = 13;
    case {10}
        ROI_siz = 20;
    case {11}
        ROI_siz = 25;
    case {12}
        ROI_siz = 30;
    case {13}
        ROI_siz = 40;
    case {14}
        ROI_siz = 50;
    case {15}
        ROI_siz = 60;
    case {16}
        ROI_siz = 70;
    case {17}
        ROI_siz = 80;
    case {18}
        ROI_siz = 90;
    case {19}
        ROI_siz = 100;
    case {20}
        ROI_siz = 110;
    case {21}
        ROI_siz = 120;
    case {22}
        ROI_siz = 140;
    case {23}
        ROI_siz = 160;
    case {24}
        ROI_siz = 180;
    case {25}
        ROI_siz = 200;
    case {26}
        ROI_siz = 220;
    case {27}
        ROI_siz = 240;
    otherwise
end