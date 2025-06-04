clc
clear

tic
%создание объекта типа Constellation, инициализация параметрами группировки Stalink из конфига
constellation = Constellation('biWalkerGlobal');

%вычисление элементов орбиты для всех КА в начальный момент
constellation.getInitialState();

% определение точек на оси времени, в которые будут проихзводиться расчёты
epochs = (0: 1000: 6000);

% расчёт положений всех КА в заданные моменты времени
constellation.propagateJ2(epochs);

% Координаты случайного КА (в инерциальных осях) после этого можно прочитать из constellation.state.eci
satIdx = randi(constellation.totalSatCount);
epochIdx = ceil(length(epochs) * rand());
disp(['Положение КА-' num2str(satIdx) ' на эпоху ' num2str(epochs(epochIdx)) ' в ECI:']);
disp(constellation.state.eci(satIdx, :, epochIdx));

% Координаты случайного КА (в осях, связанных с вращающейся Землёй) можно прочитать из constellation.state.ecef
disp(['Положение КА-' num2str(satIdx) ' на эпоху ' num2str(epochs(epochIdx)) ' в ECEF:']);
disp(constellation.state.ecef(satIdx, :, epochIdx));

% Расчёт скоростей аппратаов на каждую эпоху
constellation.velocityJ2(epochs);

% Получение информации об аппаратах в зоне видимости
dataMap = VisibleFunction(constellation, epochs, epochIdx);

% Запись данных в json-файл

container2json(dataMap, 'gatewaySatVisible.json');

disp('Для заданной эпохи найдены аппараты, находящиеся в зоне видимости шлюзовых станций.');
disp('Для каждой пары станция-аппарат определена ориентация антены, расстояние и доплеровский сдвиг.');
disp('Результат работы алгоритма записан в json-файл');
toc

% Вывод данных для пары шлюзовая станция-КА на эпоху
disp('Вывод данных для пары шлюзовая станция-КА на эпоху');
gateCount = length(jsondecode(fileread('gatewaysTest.json')));
satCount = constellation.totalSatCount;
Visualization(dataMap, gateCount, satCount, epochs(epochIdx));