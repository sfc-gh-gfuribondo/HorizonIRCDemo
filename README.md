# Snowflake Polaris + Databricks Iceberg Demo

This repository demonstrates data federation between Snowflake and Databricks using Apache Iceberg tables and Snowflake's Polaris catalog.

## 🎯 Demo Overview

**What This Demonstrates:**
- ✅ Snowflake hosting Iceberg tables with external volume
- ✅ Databricks querying Snowflake data via Polaris REST API
- ✅ Data federation without duplication
- ✅ Open table format (Apache Iceberg) for interoperability

**Architecture:**
```
┌─────────────────────────────────────────┐
│         SNOWFLAKE                        │
│  Database: DEMO_TESTDB                   │
│  Table: USER_INFO (Iceberg format)       │
│  Polaris Catalog (REST API)              │
└──────────────┬──────────────────────────┘
               │
               │ REST API over HTTPS
               │ (Iceberg protocol)
               │
┌──────────────▼──────────────────────────┐
│         DATABRICKS                       │
│  Spark + Iceberg libraries               │
│  Querying remote Iceberg tables          │
│  No data duplication!                    │
└─────────────────────────────────────────┘
```

## 📋 Prerequisites

### Snowflake Requirements:
- Snowflake account (Enterprise Edition or trial with Polaris enabled)
- ACCOUNTADMIN role access
- Polaris catalog feature enabled
- PrPr features enabled (snowflake managed storage, horizon polaris endpoint)

### Databricks Requirements:
- Databricks workspace
- Cluster with Apache Iceberg libraries installed
- Network access to Snowflake

## 🚀 Quick Start

### Step 1: Set Up Snowflake

1. Log into your Snowflake account with ACCOUNTADMIN role
2. Open a SQL worksheet
3. Run the setup script:
   ```bash
   # In Snowflake SQL worksheet, run:
   snowflake/setup_iceberg_tables.sql
   ```

This will:
- Create `DEMO_TESTDB` database
- Set up external volume for Iceberg storage
- Create `USER_INFO` Iceberg table with sample data

### Step 2: Generate Snowflake PAT Token

1. In Snowflake, go to your user profile (top right)
2. Navigate to **My Profile → Security → Personal Access Tokens**
3. Click **+ Token**
4. Name it "Databricks_Demo"
5. Copy the token (save it securely!)

### Step 3: Set Up Databricks Cluster

1. Create a new cluster or use existing one
2. Install Iceberg library:
   - Go to cluster → **Libraries** → **Install New**
   - Select **Maven**
   - Coordinates: `org.apache.iceberg:iceberg-spark-runtime-3.4_2.12:1.4.3`
     (adjust version based on your DBR version - see config/databricks_cluster_config.json)
3. **Restart the cluster** after installation

### Step 4: Configure and Run Notebook

1. Import the notebook from `notebooks/polaris_iceberg_demo.ipynb`
2. Update Cell 1 with your credentials:
   ```python
   ACCOUNTADMIN_PAT = "your_pat_token_here"
   SNOWFLAKE_ACCOUNT = "your_account_identifier"
   ```
3. Run cells in order (0 → 1 → 2 → 3 → 4)

## 📁 Repository Structure

```
OptumJamDemo/
├── README.md                           # This file
├── notebooks/
│   └── polaris_iceberg_demo.ipynb     # Main demo notebook
├── snowflake/
│   └── setup_iceberg_tables.sql       # Snowflake table setup
├── config/
│   ├── databricks_cluster_config.json # Cluster configuration template
│   └── library_requirements.txt       # Maven library coordinates
├── docs/
│   ├── DEMO_GUIDE.md                  # Presentation guide
│   └── TROUBLESHOOTING.md             # Common issues
└── .gitignore                         # Git ignore patterns
```

## 🔑 Key Files

### Notebooks
- **`polaris_iceberg_demo.ipynb`**: Complete Databricks notebook with:
  - Environment validation
  - Polaris connection configuration
  - Table discovery
  - Query execution
  - Diagnostics

### Snowflake Scripts
- **`setup_iceberg_tables.sql`**: Creates Iceberg infrastructure in Snowflake

### Configuration
- **`databricks_cluster_config.json`**: Cluster specs and library requirements
- **`library_requirements.txt`**: Maven coordinates for Iceberg libraries

## 🎓 Demo Flow

1. **Cell 0**: Validate Databricks environment
2. **Cell 1**: Configure Snowflake Polaris connection
3. **Cell 2**: Test connection and discover tables
4. **Cell 3**: Query USER_INFO table
5. **Cell 4**: Summary and next steps
6. **Cell 5**: (Optional) Diagnostics if issues occur

## 🔧 Troubleshooting

### Common Issues:

**❌ "Cannot find catalog plugin"**
- **Solution**: Install Iceberg libraries on cluster
- Maven: `org.apache.iceberg:iceberg-spark-runtime-3.4_2.12:1.4.3`

**❌ "RESTException" or "401 Unauthorized"**
- **Solution**: Verify Polaris is enabled and PAT token is valid

**❌ "Contains non-LDH ASCII characters"**
- **Solution**: Check Snowflake account identifier format
- Use hyphens, not underscores: `ORGNAME-ACCOUNTNAME`

**❌ "Attribute not supported"**
- **Solution**: Updated code handles different column names in Iceberg versions

See `docs/TROUBLESHOOTING.md` for detailed solutions.

## 📊 What's Next (Phase 2)?

After completing this demo:
1. Add more tables (CUSTOMERS, ORDERS, PRODUCTS)
2. Set up Snowflake Cortex Analyst (semantic model)
3. Create Cortex Agent for natural language queries
4. Build interactive demo presentation

## 🔒 Security Notes

- **Never commit PAT tokens** to version control
- Use Databricks secrets or environment variables in production
- The `.gitignore` file excludes sensitive files
- PAT tokens expire - check expiration date

## 📝 Configuration Notes

### Finding Your Snowflake Account Identifier:

Run this in Snowflake:
```sql
SELECT CURRENT_ACCOUNT();
SELECT CURRENT_ORGANIZATION_NAME();
```

The account identifier format:
- Format: `ORGNAME-ACCOUNTNAME`
- Example: `SFSENORTHAMERICA-DEMOGFURIBONDO`
- **Use hyphens, not underscores!**

### Databricks Runtime Versions:

| DBR Version | Iceberg Library |
|-------------|-----------------|
| DBR 12.x (Spark 3.3) | `org.apache.iceberg:iceberg-spark-runtime-3.3_2.12:1.4.3` |
| DBR 13.x, 14.x (Spark 3.4) | `org.apache.iceberg:iceberg-spark-runtime-3.4_2.12:1.4.3` |
| DBR 15.x (Spark 3.5) | `org.apache.iceberg:iceberg-spark-runtime-3.5_2.12:1.5.0` |

## 📚 Additional Resources

- [Apache Iceberg Documentation](https://iceberg.apache.org/)
- [Snowflake Polaris Catalog](https://docs.snowflake.com/en/user-guide/polaris/index.html)
- [Databricks Iceberg Integration](https://docs.databricks.com/en/delta/uniform.html)

## 👥 Support

For issues or questions:
1. Check `docs/TROUBLESHOOTING.md`
2. Run Cell 5 (Diagnostics) in the notebook
3. Review Snowflake and Databricks documentation

## 📄 License

This demo code is provided as-is for educational and demonstration purposes.

---

**Ready to start?** Follow the Quick Start steps above! 🚀

