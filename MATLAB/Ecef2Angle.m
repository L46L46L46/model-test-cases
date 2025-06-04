%   Функция переводит координаты аппарата из инерциальной СК в
%   географические координаты (широту и долготу) точки, являющейся
%   проекцией аппарата на сфере
%   Выходные данные: координаты аппарата.
%   Выходные данные: техмерынй вектор, состоящий из широты latitude,
%   долготы longitude и высоты над поверхностью altitude.
function [latitude, longitude, altitude] = Ecef2Angle(coordinates)
    earthRadius = 6378135;         % экваториальный радиус Земли [m]

    normalized = norm(coordinates(1:2));
    
    longitude = acosd (coordinates(1) / normalized);
    if coordinates(2) < 0
        longitude = 180 - longitude;
    end
    latitude = atand (coordinates(3) / normalized);
    altitude = norm(coordinates) - earthRadius;
end