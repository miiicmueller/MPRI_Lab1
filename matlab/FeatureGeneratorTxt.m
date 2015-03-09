function FeatureGeneratorTxt(file)

    addpath('Feature Extraction'); 

    [training_data,Fs,bits] = wavread([file '.wav']);
    c = melcepst(training_data,Fs);

    csvwrite([file '.txt'], c);

end
