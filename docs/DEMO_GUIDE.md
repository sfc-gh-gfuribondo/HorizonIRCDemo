# Demo Presentation Guide

This guide helps you present the Snowflake Polaris + Databricks Iceberg federation demo effectively.

## 🎯 Demo Overview

**Duration:** 15-20 minutes  
**Audience:** Technical stakeholders, data engineers, architects  
**Goal:** Demonstrate data federation using open standards (Iceberg) without data duplication

---

## 📋 Pre-Demo Checklist

✅ Snowflake setup complete (`USER_INFO` table created)  
✅ Databricks cluster running with Iceberg libraries  
✅ Notebook configured with credentials  
✅ Test run completed successfully  
✅ Screen sharing setup tested  
✅ Backup slides/screenshots ready (in case of issues)

---

## 🎬 Demo Script

### Part 1: Introduction (2-3 minutes)

**What to say:**
> "Today I'll demonstrate how organizations can achieve data federation between Snowflake and Databricks using Apache Iceberg, an open table format. This eliminates the need for ETL pipelines and data duplication."

**Show:** Architecture diagram from README.md

**Key Points:**
- Data lives in Snowflake as Iceberg tables
- Databricks queries it directly via Polaris REST API
- No data copying or ETL required
- Open standard (Apache Iceberg) - not vendor lock-in

---

### Part 2: Snowflake Setup (3-4 minutes)

**Switch to Snowflake UI**

**What to say:**
> "First, let's look at the Snowflake side. We've created an Iceberg table with external volume support."

**Show:**
1. Database `DEMO_TESTDB`
```sql
USE DATABASE DEMO_TESTDB;
SHOW ICEBERG TABLES;
```

2. Query the data
```sql
SELECT * FROM USER_INFO;
```

3. Show Iceberg metadata
```sql
SELECT SYSTEM$GET_ICEBERG_TABLE_INFORMATION('USER_INFO');
```

**Key Points:**
- Native Iceberg support in Snowflake
- External volume for flexible storage
- Polaris catalog provides REST API for external access
- Table appears normal to Snowflake users

---

### Part 3: Databricks Connection (8-10 minutes)

**Switch to Databricks Notebook**

#### Cell 0: Environment Validation

**What to say:**
> "Now let's connect from Databricks. First, we validate the environment."

**Run Cell 0**

**Highlight:**
- Java version (required for Iceberg)
- Spark version compatibility
- Spark context is active

---

#### Cell 1: Polaris Configuration

**What to say:**
> "We configure Databricks to connect to Snowflake's Polaris catalog using a REST API endpoint. Notice we're using a PAT token for authentication."

**Run Cell 1**

**Highlight:**
- Polaris REST API endpoint
- Spark catalog configuration
- Security via PAT token
- Configuration confirmation

**Key Point:** This is a one-time setup per session

---

#### Cell 2: Discovery

**What to say:**
> "Now let's discover what's available. Databricks can see the Snowflake schemas and tables through the catalog."

**Run Cell 2**

**Highlight:**
- Found the PUBLIC schema
- Discovered the USER_INFO table
- All done via REST API calls
- No data transferred yet

**Key Point:** Discovery happens through catalog metadata only

---

#### Cell 3: Query Execution

**What to say:**
> "Here's the magic - we query the Snowflake table directly from Databricks using standard Spark SQL."

**Run Cell 3**

**Highlight:**
- Simple Spark SQL syntax
- Data retrieved from Snowflake
- Row count confirmation
- Data appears as native Spark DataFrame

**Emphasize:**
- No ETL pipeline needed
- No data duplication
- Query uses Iceberg's columnar format
- Can apply Spark transformations on top

---

#### Cell 4: Summary

**What to say:**
> "Let's review what we accomplished."

**Run Cell 4**

**Highlight:**
- Architecture visualization
- Key capabilities demonstrated
- Next steps (Phase 2 with Cortex)

---

### Part 4: Use Cases & Benefits (2-3 minutes)

**What to discuss:**

**Use Cases:**
1. **Data Mesh Architecture**
   - Central data in Snowflake
   - Domain teams use Databricks for ML/analytics
   - No data duplication

2. **Cost Optimization**
   - Avoid storage duplication
   - Process data where it makes sense
   - Snowflake for warehousing, Databricks for complex analytics

3. **Real-time Access**
   - No batch ETL delays
   - Always query latest data
   - Single source of truth

**Benefits:**
- ✅ Open standards (not vendor lock-in)
- ✅ Reduced data sprawl
- ✅ Lower storage costs
- ✅ Faster time to insights
- ✅ Simplified architecture

---

### Part 5: Q&A Prep (Questions You'll Get)

**Q: How fast is it compared to local data?**
> A: Depends on data size and network. For analytics workloads, Iceberg's columnar format and predicate pushdown make it competitive. Best for batch analytics, not sub-second queries.

**Q: Can we write data from Databricks back to Snowflake?**
> A: Yes! Iceberg supports ACID transactions. You can write from Databricks and it's immediately visible in Snowflake.

**Q: What about data governance?**
> A: Snowflake maintains full governance. Databricks accesses through defined permissions. Polaris enforces Snowflake's security model.

**Q: Is this production-ready?**
> A: Yes. Both Snowflake's Polaris and Iceberg are production-grade. Many enterprises use this architecture.

**Q: What's the cost model?**
> A: You pay for Snowflake storage and Databricks compute. No data transfer charges within same cloud region.

**Q: Can other tools query these tables?**
> A: Yes! Any tool supporting Iceberg REST catalog can access - Trino, Presto, Spark, etc. That's the power of open standards.

---

## 🎨 Presentation Tips

### Do's:
- ✅ Run all cells before the demo to ensure they work
- ✅ Keep a backup of results in case of network issues
- ✅ Explain "why" not just "how"
- ✅ Relate to audience's specific use cases
- ✅ Show enthusiasm for the technology
- ✅ Have screenshot backup if live demo fails

### Don'ts:
- ❌ Rush through the configuration
- ❌ Skip explaining the architecture
- ❌ Ignore questions until the end
- ❌ Show only the happy path (acknowledge limitations)
- ❌ Forget to mention Phase 2 (Cortex)

---

## 🚀 Phase 2 Teaser

**At the end, mention:**
> "This is just Phase 1. In Phase 2, we'll add Snowflake Cortex Analyst and Agents to enable natural language queries on this federated data. Imagine asking 'Which users have Gmail addresses?' and getting automatic SQL generation and execution across this architecture."

---

## 📊 Optional: Advanced Demo Points

If time permits or audience is very technical:

### Show Iceberg Metadata
```python
# In Cell 3, add:
spark.sql("SELECT * FROM hz.PUBLIC.USER_INFO.snapshots").show()
```

### Demonstrate Time Travel
```sql
-- In Snowflake, create a snapshot
INSERT INTO USER_INFO VALUES ('demo_user', 'demo@example.com');

-- Query from Databricks shows new data immediately
```

### Show DataFrame Transformations
```python
from pyspark.sql import functions as F

# Enrich data with Spark
enriched = user_info_df.withColumn(
    "email_domain",
    F.split(F.col("EMAIL"), "@").getItem(1)
).withColumn(
    "username_length",
    F.length(F.col("USERNAME"))
)
enriched.show()
```

---

## 📝 Follow-up Materials

Provide attendees with:
- Link to this GitHub repo
- README.md for setup instructions
- TROUBLESHOOTING.md for common issues
- Contact info for questions
- Timeline for Phase 2 (Cortex) demo

---

## 🎯 Success Metrics

Your demo is successful if attendees understand:
1. ✅ Data federation eliminates duplication
2. ✅ Open standards prevent vendor lock-in
3. ✅ Both platforms maintain their strengths
4. ✅ Setup is straightforward
5. ✅ Real business value (cost, speed, governance)

---

**Good luck with your demo!** 🚀

*Remember: The technology is impressive, but focus on the business value and use cases relevant to your audience.*

