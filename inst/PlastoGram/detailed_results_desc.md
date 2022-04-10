Detailed results include predictions made by the **lower-level models** which were trained to distinguish specific classes of proteins. These predictions were used by the higher-level random forest-based model to make final predictions. 
- **Nuclear_model** - n-gram based random forest trained to differentiate nuclear-encoded (1) from plastid-encoded proteins (0).
- **Membrane_model** - n-gram based random forest trained to identify integral membrane proteins.
- **N_E_vs_N_TM_model** - n-gram based random forest trained to differentiate nuclear-encoded envelope proteins (1) from nuclear-encoded thylakoid membrane proteins (0).
- **Plastid_membrane_model** - n-gram based random forest trained to distinguish plastid-encoded inner membrane proteins (1) from plastid-encoded thylakoid membrane proteins (0).
- **N_E_vs_N_S_model** - n-gram based random forest trained to differentiate nuclear-encoded envelope proteins (1) from nuclear-encoded stromal proteins (0).
- **Nuclear_membrane_model** - n-gram based random forest trained to distinguish nuclear-encoded membrane proteins (1) from all other proteins (0).
- **Sec_model** - profile HMM model trained to identify proteins with signals responsible for targeting to the thylakoid lumen via Sec pathway
- **Tat_model** - profile HMM model trained to identify proteins with signals responsible for targeting to the thylakoid lumen via Tat pathway