git filter-branch --env-filter '
WRONG_EMAILA="asrs.contact+dev@gmail.com"
WRONG_EMAILB="asrs.contact@gmail.com"
NEW_NAME="clement.richard"
NEW_EMAIL="clement.richard@n-hop.com"

if [ "$GIT_COMMITTER_EMAIL" = "$WRONG_EMAILA" ] || [ "$GIT_COMMITTER_EMAIL" = "$WRONG_EMAILB" ]
then
    export GIT_COMMITTER_NAME="$NEW_NAME"
    export GIT_COMMITTER_EMAIL="$NEW_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$WRONG_EMAILA" ] || [ "$GIT_AUTHOR_EMAIL" = "$WRONG_EMAILB" ]
then
    export GIT_AUTHOR_NAME="$NEW_NAME"
    export GIT_AUTHOR_EMAIL="$NEW_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags

