# TrackMyCash

# 📒 TrackMyCashk – Personal Expense & Transaction Manager

TrackMyCash is a simple WhatsApp-like web application to manage customers, track transactions, and maintain daily cash flow (You Gave / You Got).  
This project is inspired by real-world KhataBook apps used by small businesses.

---

## 🚀 Features

- 🔐 User Authentication (Login / Signup)
- 👤 Add, Edit, Delete Customers
- 💸 Add Transactions:
  - You Gave
  - You Got
- 🧾 Transaction History with:
  - Date grouping (Today / Yesterday / Older)
  - Time shown below each transaction
- 📱 Mobile Responsive UI (WhatsApp-style layout)
- 🖥️ Desktop Friendly Dashboard
- 🗄️ MySQL Database (Permanent – Cloud Hosted)

---

## 🛠️ Tech Stack

### Frontend
- HTML
- CSS
- JavaScript
- JSP

### Backend
- Java Servlet
- JDBC
- Apache Tomcat 9
- Java 8

### Database
- MySQL (Hosted on Railway)

---

## 🗂️ Database Structure

### users
| Column | Type |
|------|------|
| id | INT (PK) |
| name | VARCHAR |
| email | VARCHAR |
| password | VARCHAR |

### customers
| Column | Type |
|------|------|
| id | INT (PK) |
| user_id | INT (FK) |
| name | VARCHAR |
| phone | VARCHAR |

### transactions
| Column | Type |
|------|------|
| id | INT (PK) |
| customer_id | INT (FK) |
| amount | DOUBLE |
| type | VARCHAR (GAVE / GOT) |
| note | VARCHAR |
| date | TIMESTAMP |

---

## ⚙️ Setup Instructions (Local)

1. Clone the repository
   ```bash
   git clone https://github.com/ShivtejPawar07/TrackMyCash
