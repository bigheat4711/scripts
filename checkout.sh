svn checkout -q https://svn.1and1.org/svn/dev_access_order_management/mobile-bk/OrderQueryService//trunk OrderQueryService/
svn checkout -q https://svn.1and1.org/svn/dev_access_order_management/mobile-bk/mobile-backend-connector//trunk mobile-backend-connector/
svn checkout -q https://svn.1and1.org/svn/dev_access_order_management/mobile-bk/mobile-bi-connector//trunk mobile-bi-connector/
svn checkout -q https://svn.1and1.org/svn/dev_access_order_management/mobile-bk/mobile-ccd-connector//trunk mobile-ccd-connector/
svn checkout -q https://svn.1and1.org/svn/dev_access_order_management/mobile-bk/mobile-ccs-connector//trunk mobile-ccs-connector/
svn checkout -q https://svn.1and1.org/svn/dev_access_order_management/mobile-bk/mobile-contractitem-termination//trunk mobile-contractitem-termination/
svn checkout -q https://svn.1and1.org/svn/dev_access_order_management/mobile-bk/mobile-contractitem-termination-deployer//trunk mobile-contractitem-termination-deployer/
svn checkout -q https://svn.1and1.org/svn/dev_access_order_management/mobile-bk/mobile-contractitem-termination-starter//trunk mobile-contractitem-termination-starter/
svn checkout -q https://svn.1and1.org/svn/dev_access_order_management/mobile-bk/mobile-hal-connector//trunk mobile-hal-connector/
svn checkout -q https://svn.1and1.org/svn/dev_access_order_management/mobile-bk/mobile-migration-starter//trunk mobile-migration-starter/
svn checkout -q https://svn.1and1.org/svn/dev_access_order_management/mobile-bk/mobile-mnochange-connector//trunk mobile-mnochange-connector/
svn checkout -q https://svn.1and1.org/svn/dev_access_order_management/mobile-bk/mobile-nae-article-connector//trunk mobile-nae-article-connector/
svn checkout -q https://svn.1and1.org/svn/dev_access_order_management/mobile-bk/mobile-orderfulfillment-jbpm//trunk mobile-orderfulfillment-jbpm/
svn checkout -q https://svn.1and1.org/svn/dev_access_order_management/mobile-bk/mobile-processvariables//trunk mobile-processvariables/
svn checkout -q https://svn.1and1.org/svn/dev_access_order_management/mobile-bk/mobilebk-ddt-connector//trunk mobilebk-ddt-connector/
svn checkout -q https://svn.1and1.org/svn/dev_access_order_management/mobile-bk/mobilebk-kamt-callback//trunk mobilebk-kamt-callback/
svn checkout -q https://svn.1and1.org/svn/dev_access_order_management/mobile-bk/mobilebk-orderfulfillment-services//trunk mobilebk-orderfulfillment-services/
svn checkout -q https://svn.1and1.org/svn/dev_access_order_management/mobile-bk/mobilebk_orderentry_const//trunk mobilebk_orderentry_const/
svn checkout -q https://svn.1and1.org/svn/dev_access_order_management/mobile-bk/orderfulfillment//trunk orderfulfillment/
svn checkout -q https://svn.1and1.org/svn/dev_access_order_management/mobile-bk/tpis//trunk tpis/

svn checkout -q https://svn.1and1.org/svn/dev_access_order_management/mobile-bk/ordermanagement-1.27
svn checkout -q https://svn.1and1.org/svn/dev_access_order_management/mobile-bk/mobile-migration/tags/mobile-migration-2.14.6
svn checkout -q https://svn.1and1.org/svn/dev_access_order_management/mobile-bk/ordermanagement-commons/


for D in `find . -type d`
do
  cd $d; cp --backup=t maven.log ~/temp; mvn clean install --also-make -U -DskipTests | tee maven.log; cd ..;
done
