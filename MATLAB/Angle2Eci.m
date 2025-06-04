% Функция вычисляет координаты точки в инерциальных осях
% Входные данные: структура gateway, которая содержит широту lat,
% долготу lot и высоту alt, а так же эпоха epoch, на которую производятся
% расчёты
% Выходные данные: вектор координат точки
function [eci] = Angle2Eci(gateway, epoch)
    earthAngVel = 2 * pi / 86164;  % угловая скорость вращения Земли
    ecef = Angle2Ecef(gateway);

    %вычисление матрицы поворота
    phi = earthAngVel * epoch;
    rotationMatrix = [cos(phi) -sin(phi) 0;
                     sin(phi) cos(phi) 0;
                      0 0 1];
    eci = ecef'*rotationMatrix;
end