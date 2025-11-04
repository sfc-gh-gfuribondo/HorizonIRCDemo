# Quick Start Guide

Get the demo running in 10 minutes! ⚡

## Prerequisites
- ✅ Snowflake account with ACCOUNTADMIN access
- ✅ Databricks workspace
- ✅ 10 minutes of setup time

---

## Step 1: Snowflake Setup (3 minutes)

1. **Log into Snowflake** with ACCOUNTADMIN role

2. **Run the setup script:**
   - Open `snowflake/setup_iceberg_tables.sql`
   - Copy all SQL statements
   - Paste into Snowflake SQL worksheet
   - Run all statements

3. **Verify:**
```sql
SELECT * FROM DEMO_TESTDB.PUBLIC.USER_INFO;
-- Should return 4 rows
```

✅ **Checkpoint:** You should see alice, bob, harvey, and carol

---

## Step 2: Get Snowflake PAT Token (2 minutes)

1. In Snowflake, click your **user profile** (top right)
2. Go to **My Profile → Security → Personal Access Tokens**
3. Click **+ Token**
4. Name it: `Databricks_Demo`
5. **Copy the token** (save it - you won't see it again!)
6. Note your Snowflake account identifier from the URL

✅ **Checkpoint:** You have a PAT token saved securely

---

## Step 3: Databricks Cluster Setup (3 minutes)

1. **Create/Edit cluster:**
   - Name: `DataJam` (or any name)
   - Runtime: **16.4 LTS** (or 13.x/14.x/15.x)
   - Workers: **2** (Standard_D3_v2 or similar)

2. **Install Iceberg library:**
   - Go to cluster → **Libraries** → **Install New**
   - Select **Maven**
   - Coordinates: `org.apache.iceberg:iceberg-spark-runtime-3.5_2.12:1.5.0`
     (See `config/library_requirements.txt` for other versions)
   - Click **Install**

3. **Add Spark config** (optional but recommended):
   - Go to cluster → **Advanced** → **Spark**
   - Paste from `config/databricks_cluster_config.json`

4. **Start/Restart cluster**

✅ **Checkpoint:** Cluster running with Iceberg library installed

---

## Step 4: Run the Notebook (2 minutes)

1. **Import notebook:**
   - In Databricks, go to **Workspace**
   - Import `notebooks/polaris_iceberg_demo.ipynb`

2. **Update credentials in Cell 1:**
```python
ACCOUNTADMIN_PAT = "your_token_here"          # From Step 2
SNOWFLAKE_ACCOUNT = "ORGNAME-ACCOUNTNAME"     # Your account ID
```

3. **Run cells in order:**
   - Cell 0: Environment check ✅
   - Cell 1: Configure connection ✅
   - Cell 2: Discover tables ✅
   - Cell 3: Query data ✅
   - Cell 4: Summary ✅

✅ **Checkpoint:** You should see the 4 users from Snowflake!

---

## Success! 🎉

You've successfully demonstrated:
- ✅ Snowflake hosting Iceberg tables
- ✅ Databricks querying via Polaris catalog  
- ✅ Data federation without copying
- ✅ Open standards (Apache Iceberg)

---

## What If Something Goes Wrong?

### Error: "Cannot find catalog plugin"
→ Install Iceberg library and restart cluster

### Error: "RESTException" or "401"
→ Check PAT token is valid and copied correctly

### Error: "Contains non-LDH ASCII"
→ Check account identifier uses hyphens, not underscores

### Other issues?
→ See `docs/TROUBLESHOOTING.md` for detailed solutions
→ Run Cell 5 (Diagnostics) in the notebook

---

## Next Steps

1. **Read full README.md** for detailed architecture info
2. **Review DEMO_GUIDE.md** for presentation tips
3. **Plan Phase 2:** Snowflake Cortex Analyst & Agent setup

---

## File Locations

```
OptumJamDemo/
├── QUICK_START.md                  ← You are here
├── README.md                        ← Full documentation
├── notebooks/
│   └── polaris_iceberg_demo.ipynb  ← Main notebook
├── snowflake/
│   └── setup_iceberg_tables.sql    ← Snowflake setup
├── config/
│   ├── databricks_cluster_config.json
│   └── library_requirements.txt
└── docs/
    ├── DEMO_GUIDE.md               ← Presentation guide
    └── TROUBLESHOOTING.md          ← Common issues
```

---

**Questions?** Check the full README.md or TROUBLESHOOTING.md

**Ready to present?** See DEMO_GUIDE.md for presentation tips

🚀 **Happy demoing!**

