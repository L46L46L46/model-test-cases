%   Функция на заданную эпоху для заданной констеляции и шлюзовых станций
%   опрделяет, набор аппаратов, которые находятся в зоне видимости каждой
%   из шлюзовых станций. Помимо этого, для каждой пары станция-аппарат
%   определются ориентация антены, расстояние между станцией и аппаратом,
%   а так же доплеровский сдвиг частоты радиосигнала.
%   Выходные данные: данные о констеляции - constellation, набор эпох -
%   epochs и индекс эпохи - epochIdx, на который нужно провести вычисления.
%   Выходные данные: словарь dataMap, содержащий в себе информацию о всех
%   парах типа "шлюзовая станция - аппарат в зоне её видимости". Словарь
%   имеет ключ вида 'Gate_14, Sat_26', что значит что в зоне видимости 14-й
%   шлюзовой станции находится 26-й аппарат. Значениями являются векторы из
%   четырёх параметров для каждой пары: ориентация антенны
%   (azimuth-elevation), расстояние (distance) и допплеровский сдвиг
%   частоты радиосигнала (frequency). 

function [dataMap] = VisibleFunction(constellation, epochs, epochIdx)
%% Задание параметров
    % параметры задачи
    epsilon = 25;                           % минимальный угол места в градусах
    carryingFrequency = 433e6;              % несущая частота [Hz]
    satCount = constellation.totalSatCount; % число аппаратов
    epoch = epochs(epochIdx);               % эпоха, на которую производится расчёт

%% Получение информации о шлюзовых станциях
    gatewayStationsData = jsondecode(fileread('gatewaysTest.json'));
    gateCount = length(gatewayStationsData);
    % определение координат на конкретную эпоху
    [gatewayStationsData(:).eci] = deal(zeros(3, 1));
    for gateIdx = 1:gateCount
        gatewayStationsData(gateIdx).eci = Angle2Eci(gatewayStationsData(gateIdx), epoch);
    end
%% Получение списка аппаратов в зоне видимости каждой станции
    [gatewayStationsData(:).visibleSatId] = deal([]);
    for gateIdx = 1:gateCount
        for satIdx = 1:satCount
            satCoordinates = constellation.state.eci(satIdx, :, epochIdx);
            gateCoordinates = gatewayStationsData(gateIdx).eci;
            station2satVec = satCoordinates - gateCoordinates;
            
            cosAngleEpsilon = dot(station2satVec', gateCoordinates) / (norm(gateCoordinates) * norm(station2satVec));
            if cosAngleEpsilon >= cosd(90 - epsilon)
                gatewayStationsData(gateIdx).visibleSatId(end+1) = satIdx;
            end
        end
    end

%% Создание словаря
    keys = {}; % ключ словаря в формате 'Gate_1, Sat_2', числа означают Id станции и аппарата соответственно
    values = {}; % значения словаря - четыре числа: ориентация антены azimuth-elevation, расстояние между станцией и КА и доплеровсккий сдвиг по частоте
    for gateIdx = 1:gateCount
        visibleSatCount = size(gatewayStationsData(gateIdx).visibleSatId);
        for satIdxNumber=1:visibleSatCount(2)
            satIdx = gatewayStationsData(gateIdx).visibleSatId(satIdxNumber);
            keys{end+1} = strcat('Gate_', num2str(gateIdx),'_Sat_', num2str(satIdx));

            satCoordinates = constellation.state.eci(satIdx, :, epochIdx);      % радиус-вектор аппарата
            satVelocity = constellation.state.velocityEci(satIdx, :, epochIdx); % вектор скорости аппарата
            gateCoordinates = gatewayStationsData(gateIdx).eci;                 % координаты шлюзовой станции

            % ориентация антены
            [azimuth, elevation] = AzimuthElevation(gatewayStationsData(gateIdx), satCoordinates);
            % расстояние между шлюзовой станцией и аппаратом
            distance = DistanceSatGate(gateCoordinates, satCoordinates);
            % доплеровский сдвиг частоты радиосигнала
            frequency = DoplerFrequency(gateCoordinates, satCoordinates, satVelocity, carryingFrequency);
            values{end+1} = [azimuth, elevation, distance, frequency];
        end
    end
    dataMap = containers.Map(keys, values);
end