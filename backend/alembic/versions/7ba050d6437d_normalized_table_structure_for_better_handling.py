"""normalized the table structure for better handling

Revision ID: 7ba050d6437d
Revises: f812569d29c4
Create Date: 2026-04-25

NOTE: This file was recreated because the database reports this revision
in `alembic_version`, but the revision script was missing from `alembic/versions/`.
If this revision originally contained schema operations, re-add them here
to keep history accurate.

"""

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision: str = "7ba050d6437d"
down_revision: Union[str, None] = "f812569d29c4"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Placeholder: DB is already stamped/applied at this revision.
    pass


def downgrade() -> None:
    # Placeholder
    pass

