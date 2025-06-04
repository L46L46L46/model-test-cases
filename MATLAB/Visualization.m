function[] = Visualization(dataMap, gateCount, satCount, epoch)
    prompt = "Хотите ли Вы использовать свои значения индексов КА и шлюзовой станции (Y),\nзаданные заранее значения (P) или случайные значения (R)? Y/P/R [P]: ";
    txt = input(prompt, "s");
    if isempty(txt) | txt ~= 'R' & txt ~= 'r' & txt ~= 'Y' & txt ~= 'y'
        txt = 'P';
    end
    if txt == 'R' | txt == 'r'
        satIdx = randi(satCount);
        gateIdx = randi(length(jsondecode(fileread('gatewaysTest.json'))));
    end
    if txt == 'Y' | txt == 'y'
        prompt = strcat("Введите число от 1 до ", num2str(gateCount), " - индекс шлюзовой станции: ");
        gateIdx = input(prompt);
        prompt = strcat("Введите число от 1 до ", num2str(satCount), " - индекс аппарата: ");
        satIdx = input(prompt);
    end
    if txt == 'P'
        % выделяю случайную из пар аппарат-станция, для которых аппарат
        % находится в зоне видимости станции
        keysArray = dataMap.keys();
        keysCount = length(keysArray);
        keyIdx = randi(keysCount);
        keyValue = keysArray{keyIdx};
        gateSatIdx = regexp(keyValue, '\d+', 'match');
        gateIdx = str2double(gateSatIdx{1});
        satIdx = str2double(gateSatIdx{2});
    end
    checkKey = strcat('Gate_', num2str(gateIdx),', Sat_', num2str(satIdx));
    if dataMap.isKey(checkKey)
        value = dataMap(checkKey);
        disp(['На эпоху ', num2str(epoch), ' КА ', num2str(satIdx), ' находится в зоне видимости шлюзовой станции ', num2str(gateIdx)]);
        disp(['Ориентация антены - azimuth: ', num2str(value(1)), ' elevation: ', num2str(value(2))]);
        disp(['Расстояние между аппаратом и станцией (m): ', num2str(value(3))]);
        disp(['Доплеровский сдвиг частоты радиосигнала (Hz): ', num2str(value(4))]);
    else
        disp(['На эпоху ', num2str(epoch), ' КА ', num2str(satIdx), ' не находится в зоне видимости шлюзовой станции ', num2str(gateIdx)]);
    end
end