Detailed results include predictions made by the **lower-order models** which were trained to distinguish specific classes of proteins. These predictions were used by the higher-order GLM-based model to make final predictions. 
- **Nuclear_model** - n-gram based random forest trained to differentiate nuclear-encoded (1) from plastid-encoded proteins (0).
- **Membrane_model** - n-gram based random forest trained to identify integral membrane proteins.
- **Nuclear_OM_model** - n-gram based random forest trained to differentiate nuclear-encoded outer membrane proteins (1) from other nuclear-encoded membrane proteins (0).
- **Nuclear_IM_model** - n-gram based random forest trained to distinguish nuclear-encoded inner membrane proteins (1) from other nuclear-encoded membrane proteins (0).
- **Nuclear_TM_model** - n-gram based random forest trained to differentiate nuclear-encoded thylakoid membrane proteins (1) from other nuclear-encoded membrane proteins (0).
- **Plastid_membrane_model** - n-gram based random forest trained to distinguish plastid-encoded inner membrane proteins (1) from plastid-encoded thylakoid membrane proteins (0).
- **Nuclear_OM_stroma_model** - n-gram based random forest trained to differentiate nuclear-encoded outer membrane proteins (1) from other nuclear-encoded stromal proteins (0).
- **Sec_model** - profile HMM model trained to identify proteins with signals responsible for targeting to the thylakoid lumen via Sec pathway
- **Tat_model** - profile HMM model trained to identify proteins with signals responsible for targeting to the thylakoid lumen via Tat pathway