% Функция для расчёта расстояния между шлюзовой станцей и КА
% Вход: координаты шлюзовой станции в ECI - gateCoordinates, координаты
% аппарата в ECI
% Выходные параметры: расстояние между аппаратом и станцией
function [distance] = DistanceSatGate(gateCoordinates, satCoordinates)
    distance = norm(satCoordinates - gateCoordinates);
end