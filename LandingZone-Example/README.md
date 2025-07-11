# MDC Landing-Zone
This folder is an example of how to deploy the landing-zone into the client Tenant.

## What does it deploy
- Management Groups:
    - Non-production
    - Production
    - Security Non-production
    - Security Production
- CIS L2 Policies
- Associating CIS L2 policies with every management group
- Associating all subscriptions with the correct management group
- Hub resourcegroup
- Hub virtual network & firewall subnet

## What does it not deploy
- Subscriptions themselves (Usually pre-deployed by Client together with Architect)
- The firewall itself

## What does this not deploy but MIGHT in the future
- DNS related stuff
- VPN Gateway

# Technical Details
- Uses "cicd-mgt" as service principal in this example
- Cloudspaces foundation would be based on CAF enterprise scale module from Microsoft