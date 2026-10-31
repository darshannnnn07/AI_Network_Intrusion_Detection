# AI-Based Network Intrusion Detection System (AI-NIDS)

*Intelligent Network Threat Monitoring* - a mini-project for Computer Networks (BTech CSE).

A multi-page Streamlit dashboard that uses a scikit-learn machine-learning model to classify network
flows as **Normal** or **Suspicious**, with a dark cybersecurity-style interface.

> **Educational prototype.** The built-in demo traffic, alerts and model are **synthetic**. Metrics measured on
> synthetic data show that the pipeline works; they are not evidence of real-world detection performance.

## Objectives
- Show how machine learning can analyze network-flow features to flag potentially malicious activity.
- Provide a clear workflow: upload/collect data, validate, preprocess, classify, present, inspect and export.
- Demonstrate sound ML practice: train/test split first, no data leakage, honest evaluation metrics.

## Features
| Page | What it does |
|---|---|
| Security Overview | KPI cards, traffic over time, normal vs malicious, category and severity charts, recent alerts, network activity table, demo simulation controls |
| AI Intrusion Detection | **A:** upload a CSV, preview, missing-value check, feature validation and column mapping, predictions, metrics if labels exist. **B:** manual flow form with validation, risk score, explanation, recommended action |
| Threat Alerts | Filterable alert table (severity, category, protocol, source IP, status), alert detail view, status update, CSV export |
| Traffic Explorer | Upload or reuse data, search/filter, protocol/IP/port charts, packet statistics, volume over time, simple suspicious-traffic indicators |
| Model Performance | Accuracy, precision, recall, F1, false positive rate, ROC AUC, confusion matrices, classification report, feature importance, training vs test comparison, train on your own labelled CSV (Random Forest, optional Logistic Regression comparison) |
| Live Monitor | **Demo Mode:** simulated event stream. **Live Monitoring Mode:** clearly disabled (no packet capture in this version) with prerequisites and an integration plan |
| System Information | Project details, workflow diagram, technology versions, disclaimer |

## Technology stack
Python, Streamlit, Pandas, NumPy, Scikit-learn, Plotly (plus joblib for saving models).

## Architecture
```
Streamlit pages (views/)  ->  src/state.py (session state)  ->  src/detection_model.py (Pipeline: preprocess + classifier)
        |                                                          ^
        +-> src/charts.py, src/ui.py (presentation)                +-- src/preprocessing.py, src/evaluation.py
        +-> src/data_loader.py (CSV)   src/alerts.py (severity, alerts)   src/demo_data.py (synthetic traffic)
```
The UI never contains dataset-specific logic; that lives in `src/preprocessing.py`. Training and prediction use the
same scikit-learn `Pipeline`, so identical preprocessing is applied to both.

## Folder structure
```
AI_Network_Intrusion_Detection/
  app.py                  entry point, navigation
  requirements.txt  run.bat  README.md  .gitignore
  .streamlit/config.toml  dark theme settings
  views/                  the pages (1_Security_Overview.py ... 7_Live_Monitor.py)
  src/                    data_loader, preprocessing, detection_model, evaluation, demo_data, alerts, charts, state, ui, config
  assets/                 style.css, logo.svg
  data/  models/          (empty folders with notes)
  tests/smoke_test.py     automated checks
```
The pages folder is called `views/` instead of `pages/` on purpose: Streamlit automatically treats a folder named
`pages/` as its own navigation, which bypasses this app's custom navigation and styling when a page is opened by a
direct link.

## Installation (Windows 10/11)
1. Extract the ZIP file.
2. Open the extracted `AI_Network_Intrusion_Detection` folder.
3. Open Command Prompt or PowerShell in that folder (type `cmd` in the folder's address bar and press Enter).
4. Create a virtual environment:
   ```
   python -m venv venv
   ```
5. Activate it. Command Prompt: `venv\Scripts\activate`  PowerShell: `venv\Scripts\Activate.ps1`
   (if PowerShell blocks scripts, run `Set-ExecutionPolicy -Scope Process Bypass` first).
6. Install the requirements:
   ```
   pip install -r requirements.txt
   ```
7. Run the application:
   ```
   streamlit run app.py
   ```
8. Open the local address printed in the terminal (normally http://localhost:8501).

After the one-time setup you can simply double-click **run.bat**. It uses the `venv` folder if present, checks that the
packages are installed and prints clear instructions if not. Python 3.10 or newer is required.

## Using the app
- **Demo mode:** open Security Overview. Use *Demo simulation controls* to simulate new traffic, add events or reset.
- **Upload a dataset:** AI Intrusion Detection > Method A. Upload a CSV (a synthetic sample can be downloaded there),
  check the feature table, optionally pick the label column, press *Run intrusion detection*. All other pages then
  show that analysis. Use *Reset to demo data* in the sidebar to go back.
- **Train/evaluate a model:** Model Performance > *Train on a dataset*. Choose the synthetic dataset or upload a labelled
  CSV, select the label and features, algorithm, target (multiclass or binary) and test share, then *Train and evaluate*.
  The new model becomes the active model and is saved to `models/last_trained_model.joblib`.
- **Manual analysis:** AI Intrusion Detection > Method B. Load an example or type values, then *Analyze traffic*.

## Supported input features
Default model features: `protocol`, `src_port`, `dst_port`, `flow_duration` (milliseconds in the synthetic data),
`total_fwd_packets`, `total_bwd_packets`, `total_fwd_bytes`, `total_bwd_bytes`, `pkt_len_mean`, `pkt_len_std`,
`flow_packets_per_s`, `flow_bytes_per_s`. Optional context columns: `timestamp`, `src_ip`, `dst_ip`, `label`.
Common CIC-IDS and UNSW-NB15 column names are mapped automatically. A model trained on your own data uses whichever
numeric/categorical columns you select, and units must be consistent between training and later data.

## Quality checks
`python tests/smoke_test.py` runs automated checks: ML core, CSV edge cases (empty, header-only, wrong delimiter),
missing columns, model save/load, and every page rendered headlessly with Streamlit's AppTest. The app was also loaded
in a headless Chromium browser to check navigation, CSV upload, manual analysis and the live stream. These
checks were run with Streamlit 1.66, pandas 3.0, scikit-learn 1.8, plotly 7.1 on Python 3.12 (Linux). It has not
been run on Windows or with older package versions.

## Limitations
- Demo data, alerts and the default model are synthetic; their metrics prove nothing about real networks.
- Risk score = share of the model's votes for a non-Normal class. It is not a calibrated probability.
- Severity thresholds and alert statuses are demonstration policies, not analyst decisions.
- Models are only as good as the training data; unusual units or feature definitions will hurt accuracy.
- Live packet capture is not implemented; the Live Monitoring Mode page is a disabled placeholder.
- Fonts (Inter, Space Grotesk, JetBrains Mono) load from Google Fonts and need internet; without it the app falls back
  to system fonts.
- Uploads are capped (500,000 rows read, 200,000 scored, 100,000 used for training) to keep the app responsive.

## Future enhancements
Live flow capture with a flow extractor, more algorithms and hyper-parameter search, probability calibration, SHAP
explanations, user accounts, persistent alert storage, and integration with SIEM tools.

## Customising
Edit `PROJECT_INFO` in `src/config.py` to show your own name, college and guide on the System Information page.
