"""AI-Based Network Intrusion Detection System - entry point.

Run with:  streamlit run app.py
"""
import streamlit as st

from src import state, ui
from src.config import APP_NAME

st.set_page_config(page_title=APP_NAME, page_icon=":material/shield:", layout="wide",
                   initial_sidebar_state="expanded")

PAGES = [
    st.Page("views/1_Security_Overview.py", title="Security Overview", icon=":material/dashboard:", default=True),
    st.Page("views/2_AI_Intrusion_Detection.py", title="AI Intrusion Detection", icon=":material/psychology:"),
    st.Page("views/3_Threat_Alerts.py", title="Threat Alerts", icon=":material/notifications_active:"),
    st.Page("views/4_Traffic_Explorer.py", title="Traffic Explorer", icon=":material/travel_explore:"),
    st.Page("views/5_Model_Performance.py", title="Model Performance", icon=":material/analytics:"),
    st.Page("views/7_Live_Monitor.py", title="Live Monitor", icon=":material/sensors:"),
    st.Page("views/6_System_Information.py", title="System Information", icon=":material/info:"),
]

ui.inject_css()
state.ensure_state()
ui.render_sidebar(PAGES)
st.navigation(PAGES, position="hidden").run()
