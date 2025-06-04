% Функция для расчёта ориентации антены (azimuth-elevation)
% Входные данные: структура gateway, в которой хранятся данные о шлюзовой
% станции: ее географические координаты (lon, lat) и координаты в ECI
% (eci), координаты аппарата в ECI (satCoordinates)
% Выходные параметры: углы azimuth и elevation в градусах
function [azimuth, elevation] = AzimuthElevation(gateway, satCoordinates)
        [~, satwayLon, ~] = Ecef2Angle(satCoordinates);
        
        gatewayLon = gateway.lon;
        gatewayLat = gateway.lat;
        beta = tand(gatewayLon - satwayLon) / sind(gatewayLat);
        azimuth = 180 + atand(beta);
        
        gateCoordinates = gateway.eci;
        station2satVec = satCoordinates - gateCoordinates;
        cosAngleEpsilon = dot(station2satVec', gateCoordinates) / (norm(gateCoordinates) * norm(station2satVec));
        elevation = 90 - acosd(cosAngleEpsilon);
    end