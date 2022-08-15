# Troubleshooting

## Diagnosing issues during EC2 instance set up

If you experience errors during the setup of the EC2 instance, please run the following command on the Amazon EC2 instance shell:

```shell
tail -f /var/log/cloud-init-output.log
```
