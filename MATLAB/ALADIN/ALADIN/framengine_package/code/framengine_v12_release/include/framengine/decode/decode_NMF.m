function predicted_frame = decode_NMF(featmat,NMF_params,masterframes,conf)

    slot_value_activations_NMF = calculate_obsprob_NMF(featmat,NMF_params,0,0,conf);
    
    labelvec_NMF = sum(slot_value_activations_NMF,2);
    framedesc_NMF = convert_labelvec2frame(labelvec_NMF(1:masterframes.numvalues),masterframes);
    
    predicted_frame=framedesc_NMF{1};