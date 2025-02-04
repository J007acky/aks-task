# 🌐 **Collaborative AKS Cluster Deployment**  

<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/azure/azure-original.svg" alt="Azure Logo" width="200" height="100">  

## 📖 **Overview**  
This repository documents a collaborative project where **three interns** work together to deploy and manage a robust **Azure Kubernetes Service (AKS) cluster**. The tasks are designed to encourage teamwork, exploration, and even workload distribution.  

### ✨ **Key Objectives**  
- Deploy an AKS cluster in a private Virtual Network (VNet) with appropriate permissions and external load balancer support.  
- Utilize **Azure RBAC** for managing user permissions with granular control over Kubernetes resources.  
- Expose the cluster via **two load balancers** (public and private) using **Ingress NGINX controllers**.  
- Test the cluster by deploying a **Jenkins Docker container** and ensuring accessibility through both load balancers.  
- Encourage independent research and periodic progress reviews for effective collaboration.  

---

## 🔧 **Features of the AKS Cluster**  

| **Feature**                                     | **Description**                                                                                       |
|-------------------------------------------------|-------------------------------------------------------------------------------------------------------|
| **Private VNet**                                | The cluster is deployed inside a private VNet with provisions for external load balancing.            |
| **Templating with Bicep**                       | Deployment configurations use **Bicep templates** to standardize and automate resource provisioning.  |
| **Azure RBAC Integration**                      | Leverages Azure Role-Based Access Control for secure and granular user management via **Entra users**.|
| **Dual Load Balancers**                         | Configured with both public and private load balancers using **Ingress NGINX controllers**.           |
| **Jenkins Deployment**                          | A Jenkins Docker container is deployed to test cluster performance and accessibility.                 |


---


## 🌟 **Key Tools and Technologies**  

| **Tool**        | **Logo**                                                                                             |
|------------------|-----------------------------------------------------------------------------------------------------|
| **Azure AKS**    | <img alt="Azure AKS" width="50px" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/azure/azure-original.svg" />  |
| **Bicep**        | <img alt="Bicep" width="50px" src="https://i0.wp.com/gregorsuttie.com/wp-content/uploads/2023/07/biceplogo-removebg-preview.png?ssl=1" />               |
| **Ingress NGINX**| <img alt="NGINX" width="50px" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/nginx/nginx-original.svg" />       |
| **Jenkins**      | <img alt="Jenkins" width="50px" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/jenkins/jenkins-original.svg" />  |

---

## 👨‍💻 **Contributors**  
1. Rahul Singh Rautela  
2. Alok Raturi
3. Madhur Gupta  

Let’s work together to make this project a success! 🚀
