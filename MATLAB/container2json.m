% Функция преобразует словарь в json-файл
function [] = container2json(dataMap, fileName)
    % Пеобразование в структуру
    keys = dataMap.keys;
    values = dataMap.values;
    dictStruct = struct();
    for i = 1:length(keys)
        data4valueStruct = struct('azimuth', values{i}(1), 'elevation', values{i}(2), ...
            'distance', values{i}(3), 'frequency', values{i}(4));
        dictStruct.(keys{i}) = data4valueStruct;
    end
    
    % Запись в json-файл
    file = fopen(fileName, 'w');
    fprintf(file, '%s', jsonencode(dictStruct, PrettyPrint=true));
    fclose(file);
end