% Функция вычисляет координаты точки в осях, связанных с Землей
% Входные данные: структура gateway, которая содержит широту lat,
% долготу lot и высоту alt
% Выходные данные: вектор координат точки
function [ecef] = Angle2Ecef(gateway)
    lat = gateway.lat;             % широта
    lon = gateway.lon;             % долгота
    altitude = gateway.altitude;   % высота над поверхноостью Земли
    earthRadius = 6378135;         % экваториальный радиус Земли [m]
    ecef = (earthRadius + altitude) * [cosd(lat) * cosd(lon);
                                      cosd(lat) * sind(lon);
                                      sind(lat)];
end