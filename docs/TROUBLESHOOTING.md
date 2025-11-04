# Troubleshooting Guide

This guide covers common issues you might encounter when setting up the Snowflake Polaris + Databricks Iceberg demo.

## Table of Contents
- [Databricks Issues](#databricks-issues)
- [Snowflake Issues](#snowflake-issues)
- [Connection Issues](#connection-issues)
- [Data Query Issues](#data-query-issues)

---

## Databricks Issues

### ❌ "Cannot find catalog plugin class"

**Error:**
```
Cannot find catalog plugin class for catalog 'hz': org.apache.iceberg.spark.SparkCatalog
```

**Cause:** Iceberg libraries are not installed on the cluster.

**Solution:**
1. Go to your cluster → **Libraries** tab
2. Click **Install New**
3. Select **Maven**
4. Enter coordinates based on your DBR version:
   - **DBR 16.x** (Spark 3.5): `org.apache.iceberg:iceberg-spark-runtime-3.5_2.12:1.5.0`
   - **DBR 13-14.x** (Spark 3.4): `org.apache.iceberg:iceberg-spark-runtime-3.4_2.12:1.4.3`
5. Click **Install**
6. **Restart your cluster**

---

### ❌ "Cannot create catalog hz, both type and catalog-impl are set"

**Error:**
```
IllegalArgumentException: Cannot create catalog hz, both type and catalog-impl are set: 
type=rest, catalog-impl=org.apache.iceberg.rest.RESTCatalog
```

**Cause:** Conflicting Spark configuration settings.

**Solution:**
1. **Option A:** Restart your cluster to clear old configurations
2. **Option B:** Run this code in a cell before Cell 1:
```python
# Clear conflicting configurations
all_configs = spark.sparkContext.getConf().getAll()
catalog_keys = [key for key, value in all_configs if 'catalog.hz' in key]
for key in catalog_keys:
    try:
        spark.conf.unset(key)
    except:
        pass
```
3. Then re-run Cell 1

---

### ❌ "Attribute `namespace` is not supported"

**Error:**
```
[ATTRIBUTE_NOT_SUPPORTED] Attribute `namespace` is not supported.
```

**Cause:** Different Iceberg versions use different column names.

**Solution:** This is already handled in the updated notebook. The code now checks for both `databaseName` and `namespace` column names.

If you see this error, make sure you're using the latest version of the notebook from this repo.

---

## Snowflake Issues

### ❌ Polaris Not Available

**Error:**
```
RESTException: Error occurred while processing POST request
```

**Cause:** Polaris catalog is not enabled on your Snowflake account.

**Solution:**
1. Check if Polaris is available:
```sql
SHOW PARAMETERS LIKE '%POLARIS%' IN ACCOUNT;
```

2. If not available, contact Snowflake support or:
   - Use the JDBC/Snowflake Spark Connector approach instead
   - Upgrade to Enterprise Edition if on Standard

---

### ❌ Table Not Found

**Error:**
```
Table USER_INFO not found
```

**Cause:** Setup script wasn't run or failed.

**Solution:**
1. In Snowflake, verify the table exists:
```sql
USE DATABASE DEMO_TESTDB;
SHOW ICEBERG TABLES;
SELECT * FROM USER_INFO;
```

2. If table doesn't exist, run the setup script:
```sql
-- Run snowflake/setup_iceberg_tables.sql
```

---

## Connection Issues

### ❌ "Contains non-LDH ASCII characters"

**Error:**
```
java.lang.IllegalArgumentException: Contains non-LDH ASCII characters
```

**Cause:** Snowflake account identifier contains invalid characters (like underscores).

**Solution:**
1. Find your correct account identifier in Snowflake:
```sql
SELECT CURRENT_ACCOUNT();
SELECT CURRENT_ORGANIZATION_NAME();
```

2. Format should be:
   - ✅ `ORGNAME-ACCOUNTNAME` (with hyphens)
   - ❌ `ORGNAME_ACCOUNTNAME` (underscores cause errors)

3. Update Cell 1 in the notebook with the correct identifier

---

### ❌ "401 Unauthorized" or "403 Forbidden"

**Error:**
```
RESTException: 401 Unauthorized
```

**Cause:** PAT token is invalid, expired, or doesn't have permissions.

**Solution:**
1. Generate a new PAT token:
   - In Snowflake → User Profile → Security → Personal Access Tokens
   - Create new token
   - Copy it immediately (you won't see it again!)

2. Check token expiration:
```python
import jwt
decoded = jwt.decode(ACCOUNTADMIN_PAT, options={"verify_signature": False})
print(f"Token expires: {decoded.get('exp')}")
```

3. Update Cell 1 with the new token

---

### ❌ Network/SSL Errors

**Error:**
```
SSLHandshakeException or Connection refused
```

**Cause:** Network connectivity issues or firewall blocking.

**Solution:**
1. Check if you can reach Snowflake:
```python
import urllib.request
url = f"https://{SNOWFLAKE_ACCOUNT}.snowflakecomputing.com"
try:
    response = urllib.request.urlopen(url, timeout=10)
    print(f"✅ Can reach Snowflake: {response.status}")
except Exception as e:
    print(f"❌ Cannot reach Snowflake: {e}")
```

2. Check Databricks network settings:
   - Ensure outbound HTTPS (port 443) is allowed
   - Check if VPC/firewall allows Snowflake connections

---

## Data Query Issues

### ❌ Empty Result Set

**Error:** Query returns 0 rows

**Cause:** Table is empty or filter is too restrictive.

**Solution:**
1. Check in Snowflake:
```sql
SELECT COUNT(*) FROM USER_INFO;
SELECT * FROM USER_INFO LIMIT 10;
```

2. If empty, load data:
```sql
INSERT INTO USER_INFO VALUES 
  ('alice', 'alice@example.com'),
  ('bob', 'bob@example.com'),
  ('harvey', 'harvey@example.com'),
  ('carol', 'carol@example.com');
```

---

### ❌ "Column not found" Errors

**Error:**
```
AnalysisException: Column 'USERNAME' does not exist
```

**Cause:** Column names are case-sensitive or table schema changed.

**Solution:**
1. Check actual column names:
```python
df = spark.sql("SELECT * FROM hz.PUBLIC.USER_INFO")
df.printSchema()
```

2. Use correct case in queries

---

## Diagnostic Tools

### Run Cell 5 (Diagnostics)

The notebook includes a comprehensive diagnostics cell. Run it to check:
- ✅ Iceberg libraries installed
- ✅ Catalog configuration
- ✅ Network connectivity
- ✅ PAT token format
- ✅ All Spark configurations

### Manual Checks

**Check Spark Configurations:**
```python
all_configs = spark.sparkContext.getConf().getAll()
for key, value in all_configs:
    if 'catalog' in key.lower() or 'iceberg' in key.lower():
        print(f"{key} = {value}")
```

**Test Iceberg Classes:**
```python
try:
    spark.sparkContext._jvm.org.apache.iceberg.spark.SparkCatalog
    print("✅ Iceberg classes available")
except Exception as e:
    print(f"❌ Iceberg classes not found: {e}")
```

**Verify Snowflake Credentials:**
```python
print(f"Account: {SNOWFLAKE_ACCOUNT}")
print(f"Database: {DATABASE_NAME}")
print(f"PAT Token Length: {len(ACCOUNTADMIN_PAT)}")
print(f"PAT Token Format: {'JWT' if ACCOUNTADMIN_PAT.count('.') == 2 else 'Unknown'}")
```

---

## Still Having Issues?

1. **Check the Snowflake documentation:** [Polaris Catalog](https://docs.snowflake.com/en/user-guide/polaris/)
2. **Check Databricks documentation:** [Iceberg Integration](https://docs.databricks.com/en/delta/uniform.html)
3. **Review Iceberg docs:** [Apache Iceberg](https://iceberg.apache.org/)
4. **Contact support:** Snowflake or Databricks support teams

---

## Quick Reference: Error → Solution

| Error Message | Quick Fix |
|---------------|-----------|
| Cannot find catalog plugin | Install Iceberg libraries |
| Both type and catalog-impl set | Restart cluster |
| Contains non-LDH ASCII | Fix account identifier (no underscores) |
| 401 Unauthorized | Generate new PAT token |
| RESTException | Check Polaris is enabled |
| Table not found | Run Snowflake setup script |
| Attribute not supported | Use updated notebook |
| Connection refused | Check network/firewall settings |

---

**Last Updated:** November 2025

