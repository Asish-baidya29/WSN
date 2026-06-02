# =============================================================================
# database.py  —  MySQL 5 connection via SQLAlchemy + PyMySQL
# =============================================================================
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
from config import DATABASE_URL
import logging

logger = logging.getLogger(__name__)

engine = create_engine(
    DATABASE_URL,
    pool_pre_ping=True,
    pool_recycle=3600,
    pool_size=5,
    max_overflow=10,
    echo=False,
)

SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine,
)


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def call_procedure(db, proc_name: str, params: list):
    try:
        placeholders = ", ".join([":p" + str(i) for i in range(len(params))])
        param_dict = {"p" + str(i): v for i, v in enumerate(params)}
        sql = text(f"CALL {proc_name}({placeholders})")
        db.execute(sql, param_dict)
        db.commit()
        logger.debug(f"Procedure {proc_name} called with {params}")
    except Exception as e:
        db.rollback()
        logger.error(f"Error calling procedure {proc_name}: {e}")
        raise


def fetch_one(db, sql: str, params: dict = None):
    try:
        result = db.execute(text(sql), params or {})
        row = result.fetchone()
        if row is None:
            return None
        return dict(row._mapping)
    except Exception as e:
        logger.error(f"fetch_one error: {e}")
        raise


def fetch_all(db, sql: str, params: dict = None):
    try:
        result = db.execute(text(sql), params or {})
        rows = result.fetchall()
        return [dict(row._mapping) for row in rows]
    except Exception as e:
        logger.error(f"fetch_all error: {e}")
        raise


def execute_sql(db, sql: str, params: dict = None):
    try:
        db.execute(text(sql), params or {})
        db.commit()
    except Exception as e:
        db.rollback()
        logger.error(f"execute_sql error: {e}")
        raise


def test_connection():
    try:
        with engine.connect() as conn:
            conn.execute(text("SELECT 1"))
        logger.info("Database connection successful.")
        return True
    except Exception as e:
        logger.error(f"Database connection FAILED: {e}")
        return False