from setuptools import setup, find_packages

setup(
    name='example-databricks-submit-job',
    version='0.1',
    install_requires=[
        'Keras==2.1.6',
        'h5py==2.7.1',
        'opencv-python==3.4.1.15',
        'pydicom',
        'imageio==2.2.0',
        'pandas',
        'tensorflow-gpu<1.9'
    ],
    packages=find_packages(),
    include_package_data=True,
    description='databricks-submit-job-example'
)