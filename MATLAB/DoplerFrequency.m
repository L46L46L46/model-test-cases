% Функция для констеляции и шлюзовых станций вычисляет допплеровский сдвиг
% частоты радиосигнала
% Вход: координаты шлюзовой станции в ECI - gateCoordinates, координаты
% аппарата в ECI - satCoordinates, скорость аппарата в ECI - satVelocity
% несущая частота - carryingFrequency
% Выходные параметры: частота смещения радиосигнала
function [frequency] = DoplerFrequency(gateCoordinates, satCoordinates, satVelocity, carryingFrequency)
    %константы
    earthGM = 3.986004415e+14;              % гравитационный параметр Земли [m3/s2]
    earthAngVel = 2 * pi / 86164;           % угловая скорость вращения Земли
    cLight = 2.99792458e8;                  % скорость света
    
    satHeight = norm(satCoordinates);                                                          % высота орбиты аппарата
    gateVelocity = earthAngVel * [- gateCoordinates(2); gateCoordinates(1); 0];                % скорость станции в ECI

    visibleVector = (satCoordinates - gateCoordinates)/norm(satCoordinates - gateCoordinates); % вектор передачи сигнала
    cosGateVisible = dot(gateVelocity, visibleVector);                                         % проекция скорости станции на направление передачи
    cosSatVisible = dot(satVelocity, visibleVector);                                           % проекция скорости аппарата на направление передачи

    velocityRef = cosSatVisible - cosGateVisible;
    gravRedshift = earthGM / cLight * (1 / earthRadius - 1 / norm(satHeight));                 % гравитационное красное смещение
    frequency = carryingFrequency / cLight  * (velocityRef + gravRedshift);
end