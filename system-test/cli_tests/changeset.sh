#!/bin/bash

header "Changeset"

# synchronize repo to load the packages
#test_success "repo synchronize" repo synchronize --id="$REPO_ID"
test_success "product synchronize" product synchronize --org="$TEST_ORG" --name="$FEWUPS_PRODUCT"

CS_TEST_VIEW="${TEST_VIEW}_cs"
test_success "content definition publish ($TEST_DEF to $CS_TEST_VIEW)" content definition publish --org=$TEST_ORG --label=$TEST_DEF --view_name=$CS_TEST_VIEW

# testing changesets
CS_NAME="changeset_$RAND"
CS_NAME_2="changeset_2_$RAND"
CS_NAME_3="changeset_3_$RAND"
test_success "changeset create" changeset create --org="$TEST_ORG" --environment="$TEST_ENV" --name="$CS_NAME"
test_failure "changeset add product" changeset update  --org="$TEST_ORG" --environment="$TEST_ENV" --name="$CS_NAME" --add_product="$FEWUPS_PRODUCT"

check_delayed_jobs_running

test_success "promote changeset with one product" changeset promote --org="$TEST_ORG" --environment="$TEST_ENV" --name="$CS_NAME"

test_success "changeset create" changeset create --org="$TEST_ORG" --environment="$TEST_ENV" --name="$CS_NAME_2"
test_failure "changeset add package"  changeset update  --org="$TEST_ORG" --environment="$TEST_ENV" --name="$CS_NAME_2" --from_product="$FEWUPS_PRODUCT" --add_package="monkey-0.3-0.8.noarch"
test_failure "changeset add erratum"  changeset update  --org="$TEST_ORG" --environment="$TEST_ENV" --name="$CS_NAME_2" --from_product="$FEWUPS_PRODUCT" --add_erratum="RHEA-2010:0001"
test_failure "changeset add repo"     changeset update  --org="$TEST_ORG" --environment="$TEST_ENV" --name="$CS_NAME_2" --from_product="$FEWUPS_PRODUCT" --add_repo="$REPO_NAME"
test_success "changeset add view"     changeset update  --org="$TEST_ORG" --environment="$TEST_ENV" --name="$CS_NAME_2" --add_content_view="$CS_TEST_VIEW"

test_success "changeset promote" changeset promote --org="$TEST_ORG" --environment="$TEST_ENV" --name="$CS_NAME_2"

test_success "changeset list" changeset list --org="$TEST_ORG" --environment="$TEST_ENV"
test_success "changeset info" changeset info --org="$TEST_ORG" --environment="$TEST_ENV" --name="$CS_NAME"

test_failure "changeset remove product"  changeset update  --org="$TEST_ORG" --environment="$TEST_ENV" --name="$CS_NAME" --remove_product="$FEWUPS_PRODUCT"
test_failure "changeset remove package"  changeset update  --org="$TEST_ORG" --environment="$TEST_ENV" --name="$CS_NAME_2" --from_product="$FEWUPS_PRODUCT" --remove_package="monkey-0.3-0.8.noarch"
test_failure "changeset remove erratum"  changeset update  --org="$TEST_ORG" --environment="$TEST_ENV" --name="$CS_NAME_2" --from_product="$FEWUPS_PRODUCT" --remove_erratum="RHEA-2010:0001"
test_failure "changeset remove repo"     changeset update  --org="$TEST_ORG" --environment="$TEST_ENV" --name="$CS_NAME_2" --from_product="$FEWUPS_PRODUCT" --remove_repo="$REPO_NAME"
test_success "changeset remove view"     changeset update  --org="$TEST_ORG" --environment="$TEST_ENV" --name="$CS_NAME_2" --remove_content_view_label="$CS_TEST_VIEW"

test_success "changeset update" changeset update --org="$TEST_ORG" --environment="$TEST_ENV" --name="$CS_NAME" --new_name="new_$CS_NAME" --description="updated description"
