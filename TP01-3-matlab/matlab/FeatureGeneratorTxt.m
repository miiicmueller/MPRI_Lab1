function FeatureGeneratorTxt(file)

    addpath('Feature Extraction'); 

    [training_data,Fs,bits] = wavread([file '.wav']);
    
    training_data = training_data/1.0;
    Fs = Fs/1.0;
    
    c = melcepst(training_data,Fs);

    csvwrite([file '.txt'], c);

end
