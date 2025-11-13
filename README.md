# 📊 OECD Housing Price Dashboard (R Shiny)

An interactive dashboard built with **R Shiny** to explore quarterly housing price trends across OECD countries.  
The app provides users with the ability to compare housing cost indices over time, switch between nominal/real perspectives,  
and highlight specific countries for deeper analysis.

---

## 🧭 Features

### 🔍 **Exploratory Visualizations**
- Quarterly housing price index (nominal or real)
- Compare countries using:
  - **Point plots** (prices at a selected date)
  - **Line plots** (overall trend)
- Adjustable **timeline range**

### ⚙️ **Interactive Controls**
- Select multiple countries to highlight
- Switch between **linear** and **logarithmic** scales
- Choose:
  - Base date *(Index = 100)*  
  - Target comparison date  
  - Time range slider

### 🧠 **Dynamic Data Processing**
- Automatic transformation of OECD quarterly format into real dates  
- Normalization of housing prices relative to a selected base year  
- Reactive UI updates linked to user selections  

---

## 🛠️ Tech Stack

- **R Shiny**
- **ggplot2** + **plotly**
- **data.table**
- OECD Housing CSV dataset

---

## 📷 Screenshots

<img width="2048" height="847" alt="housing_dashboard@2x" src="https://github.com/user-attachments/assets/7cb9a0f1-caeb-4e2e-b97c-4de28e794953" />

---

## 🚀 How to Run

```r
# Install required packages
install.packages(c("shiny", "ggplot2", "plotly", "data.table", "readr"))

# Run the app
shiny::runApp("app_directory/")
```

---

## 📌 Project Goals

- Provide policymakers and analysts with an intuitive view of housing cost trends  
- Allow comparative analysis across countries and economic cycles  
- Enable flexible baseline and perspective switching for deeper insight  

---

## 🧑‍💻 Author
Weilun LIN
